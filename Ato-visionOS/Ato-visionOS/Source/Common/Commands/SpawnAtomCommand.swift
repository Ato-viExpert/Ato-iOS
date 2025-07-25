//
//  SpawnAtomCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/16/25.
//

import SwiftUI
import RealityKit

/// 주어진 원자 타입(AtomType)에 해당하는 AtomEntity를 생성하고 씬에 추가하는 커맨드입니다.
/// 실행 시 새로운 원자 엔티티를 생성하거나 기존 생성된 엔티티를 재추가하고,
/// undo 시 해당 엔티티를 씬에서 제거합니다.
final class SpawnAtomCommand: Command {
    // MARK: - Properties
    
    private let atomType: AtomType
    private var spawnedEntity: AtomEntity?
    
    // MARK: - Init
    
    /// SpawnAtomCommand 초기화
    /// - Parameter atomType: 생성할 AtomEntity의 원소 타입
    init(atomType: AtomType) {
        self.atomType = atomType
    }
    
    // MARK: - Methods
    
    /// AtomEntity를 생성하여 RealityViewContent 내 main-anchor에 추가합니다.
    /// 이미 생성된 엔티티가 있다면 재사용하여 다시 추가합니다.
    /// - Parameter content: RealityView에 배치된 RealityViewContent
    /// - Returns: 생성된 AtomEntity를 포함한 CommandResult
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        if let existingEntity = spawnedEntity {

            await MainActor.run {
                if let anchor = content.entities.first(where: { $0.name == "main-anchor" }) as? AnchorEntity {
                    anchor.addChild(existingEntity)
                }
            }
            
            return .entity(existingEntity)
        }
        let instance = AtomInstance(type: atomType)
        let atomEntity = try await AtomEntity(instance: instance)
        spawnedEntity = atomEntity
        
        await MainActor.run {
            if let anchor = content.entities.first(where: { $0.name == "main-anchor" }) as? AnchorEntity {
                anchor.addChild(atomEntity)
            }
        }
        return .entity(atomEntity)
    }
    
    /// RealityViewContent 내에서 생성한 AtomEntity를 제거하여 undo를 수행합니다.
    /// - Parameter content: RealityView에 배치된 RealityViewContent
    /// - Returns: 제거된 AtomEntity를 포함한 CommandResult
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        guard let entity = spawnedEntity else { return .none }
        await entity.removeFromParent()
        return .entity(entity)
    }
}


// MARK: - MolecularDetailAlgorithm 
extension SpawnAtomCommand {
    // 원자 결합 예측
    /// input -> 두개의 원자
    /// output -> 두개의 원자가 결합 할 경우 어떤 결합을 하게 되는지(불가일 경우 0)
    private func predictBondOrder(atomA: LabAtomEntity, atomB: LabAtomEntity) -> Int {
        // 조건 1: 남은 홑전자가 있어야 함
        guard atomA.unpairedElectrons > 0, atomB.unpairedElectrons > 0 else {
            return 0
        }

        // 조건 2: 현재 전자 수가 옥텟 이상이면 더 이상 결합 불가
        guard atomA.currentElectronCount < atomA.maxElectronCount,
            atomB.currentElectronCount < atomB.maxElectronCount else {
            return 0
        }

        // 조건 3: 필요한 전자 수 계산
        let needA = atomA.maxElectronCount - atomA.currentElectronCount
        let needB = atomB.maxElectronCount - atomB.currentElectronCount

        let maxPossibleBond = min(atomA.unpairedElectrons, atomB.unpairedElectrons)
        let requiredBond = min(needA, needB, 3)

        return min(maxPossibleBond, requiredBond)
    }
    
    // 결합 불가능한 경우 처리
    private func wrongChoice() -> Void {
        print("결합 불가")
    }

    // 원자의 결합 상태 변화(결합, 결합 전자 수, 홀전자 수 변화)
    private func changeAtomState(atomA: LabAtomEntity, atomB: LabAtomEntity, bond: Int) -> (LabAtomEntity, LabAtomEntity) {
        atomA.bonds.append(Bond(atomUUID: atomB.atomUUID, bondType: bond))
        atomB.bonds.append(Bond(atomUUID: atomA.atomUUID, bondType: bond))
        atomA.unpairedElectrons -= bond
        atomB.unpairedElectrons -=  bond
        atomA.sharedElectrons += bond
        atomB.sharedElectrons += bond
        return (atomA, atomB)
    }

    // 원자의 분자 고유 번호 변화
    private func changeAtomUUID(atom: LabAtomEntity, moleculeUUID: UUID) -> LabAtomEntity {
        atom.moleculeUUID = moleculeUUID
        return atom
    }

    // 분자 안정성 판단
    private func checkMoleculeStable(molecule: MoleculeEntity) -> Bool {
        for atom in molecule.atoms {
            if atom.unpairedElectrons > 0 || atom.currentElectronCount == atom.maxElectronCount {
                return false
            }
        }
        return true
    }

    // 분자 생성(원자 2개가 결합할 경우)
    private func createMolecule(atomA: LabAtomEntity, atomB: LabAtomEntity, bond: Int) -> MoleculeEntity {
        let molecule = MoleculeEntity(moleculeUUID: UUID(), atoms: [atomA, atomB], stable: false)
        molecule.stable = checkMoleculeStable(molecule: molecule)

        return molecule
    }

    // 분자 상태 변화(기존 분자에 새로운 원자 추가)
    /// input -> 원자, 분자
    /// output -> 분자
    private func changeMoleculeState(atom: LabAtomEntity, molecule: MoleculeEntity) -> MoleculeEntity {
        molecule.atoms.append(atom)
        molecule.stable = checkMoleculeStable(molecule: molecule)
        return molecule
    }

    // 분자 상태 변화(분자 두개 한개로 합치기)
    /// input -> 분자, 분자
    /// output -> 분자
    private func changeMoleculeState(moleculeA: MoleculeEntity, moleculeB: MoleculeEntity) -> MoleculeEntity {
        moleculeA.atoms.append(moleculeB.atoms)
        moleculeA.stable = checkMoleculeStable(molecule: moleculeA)
        return moleculeA
    }


    // 분자 생성
    /// 원자 두개를 받을지, 원자와 분자를 받을지, 분자 두개를 받을 지 상황에 따라 다름

    // 원자 결합
    func createBondedAtoms(atomA: LabAtomEntity, atomB: LabAtomEntity) -> Void {
        let bondOrder = predictBondOrder(atomA: atomA, atomB: atomB)
        if bondOrder == 0 {
            wrongChoice()
        }
        if atomA.moleculeUUID == nil && atomB.moleculeUUID == nil {
            let molecule = createMolecule(atomA: atomA, atomB: atomB, bond: bondOrder)
            atomA = changeAtomUUID(atom: atomA, moleculeUUID: molecule.moleculeUUID)
            atomB = changeAtomUUID(atom: atomB, moleculeUUID: molecule.moleculeUUID)
            return molecule, atomA, atomB
        } else if atomA.moleculeUUID == nil && atomB.moleculeUUID != nil {
            let molecule = createMolecule(atomA: atomA, atomB: atomB, bond: bondOrder)
            atomA = changeAtomUUID(atom: atomA, moleculeUUID: molecule.moleculeUUID)
        }else {
            let molecule = createMolecule(atomA: atomA, atomB: atomB, bond: bondOrder)
            atomA = changeAtomUUID(atom: atomA, moleculeUUID: molecule.moleculeUUID)
            atomB = changeAtomUUID(atom: atomB, moleculeUUID: molecule.moleculeUUID)
        }
    }
}