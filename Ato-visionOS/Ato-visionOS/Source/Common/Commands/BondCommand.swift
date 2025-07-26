//
//  BondCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import SwiftUI
import RealityKit

/// 두 Bondable 객체를 결합하여 MoleculeEntity를 생성하는 커맨드
final class BondCommand: Command {
    
    // MARK: - Properties
    
    private let first: Bondable
    private let second: Bondable
    private var molecule: MoleculeEntity?
    
    private var firstTransform: Transform?
    private var secondTransform: Transform?
    
    // MARK: - Init
    
    /// BondCommand를 초기화합니다.
    /// - Parameters:
    ///   - first: 결합 대상이 되는 첫 번째 Bondable 객체
    ///   - second: 결합 대상이 되는 두 번째 Bondable 객체
    init(first: Bondable, second: Bondable) {
        self.first = first
        self.second = second
    }
    
    // MARK: - Methods
    
    /// 두 Bondable 객체를 결합하여 하나의 MoleculeEntity를 생성하고, 콘텐츠에 추가합니다.
    /// - Parameter content: 결합된 엔티티를 추가할 RealityViewContent
    /// - Returns: 성공적으로 결합되면 `.entity(molecule)`를 반환하고, 결합이 불가능할 경우 `.none` 반환
    /// - Throws: 결합 중 에러가 발생할 경우 오류를 던짐
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        guard BondCommand.canBond(first: first, second: second) else {
            return .none
        }
        
        // 현재 위치 저장
        let firstEntity = first.entity
        let secondEntity = second.entity
        
        self.firstTransform = await firstEntity.transform
        self.secondTransform = await secondEntity.transform
        
        // 부모에서 제거 (원자/분자를 하나로 만들기 위해)
        await firstEntity.removeFromParent()
        await secondEntity.removeFromParent()
        
        // 새로운 MoleculeEntity 생성
        let molecule = await MoleculeEntity(central: first, peripheral: second)
        self.molecule = molecule
        
        await MainActor.run {
            if let anchor = content.entities.first(where: { $0.name == "main-anchor" }) {
                anchor.addChild(molecule)
            } else {
                content.add(molecule)
            }
        }
        
        return .entity(molecule)
    }
    
    /// 이전에 결합된 MoleculeEntity를 제거하고, 원래의 Bondable 엔티티 두 개를 복원합니다.
    /// - Parameter content: 복원된 엔티티를 다시 추가할 RealityViewContent
    /// - Returns: Undo 결과로 아무것도 반환하지 않으며 `.none`을 반환
    /// - Throws: Undo 처리 중 에러가 발생할 경우 오류를 던짐
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        guard let molecule else { return .none }
        await molecule.removeFromParent()
        
        let firstEntity = first.entity
        let secondEntity = second.entity
        
        if let t1 = firstTransform {
            await MainActor.run { firstEntity.transform = t1 }
        }
        if let t2 = secondTransform {
            await MainActor.run { secondEntity.transform = t2 }
        }
        
        await MainActor.run {
            if let anchor = content.entities.first(where: { $0.name == "main-anchor" }) {
                anchor.addChild(firstEntity)
                anchor.addChild(secondEntity)
            } else {
                content.add(firstEntity)
                content.add(secondEntity)
            }
        }
        return .none
    }
    
    /// 두 Bondable 객체가 결합 가능한지 여부를 판단합니다.
    /// - Parameters:
    ///   - first: 첫 번째 결합 대상
    ///   - second: 두 번째 결합 대상
    /// - Returns: 결합이 가능하면 `true`, 불가능하면 `false`
    private static func canBond(first: Bondable, second: Bondable) -> Bool {
        if first.bondsRemaining <= 0 {
            print("❌ 첫 번째 원자(\(first.symbol))는 더 이상 결합할 수 없습니다.")
            return false
        }
        
        if second.bondsRemaining <= 0 {
            print("❌ 두 번째 원자(\(second.symbol))는 더 이상 결합할 수 없습니다.")
            return false
        }
        
        if first.type.group == 18 || second.type.group == 18 {
            print("❌ 비활성 기체(18족)는 결합하지 않습니다.")
            return false
        }
        
        return true
    }
}

// MARK: - MolecularDetailAlgorithm
extension BondCommand {
    // 원자 결합 예측
    /// input -> 두개의 원자
    /// output -> 두개의 원자가 결합 할 경우 어떤 결합을 하게 되는지(불가일 경우 0)
    private func predictBondOrder(atomA: LabAtom, atomB: LabAtom) -> Int {
        // 조건 1: 남은 홑전자가 있어야 함
        guard atomA.unpairedElectrons > 0, atomB.unpairedElectrons > 0 else {
            return 0
        }

        // 조건 2: 현재 전자 수가 옥텟 이상이면 더 이상 결합 불가
        guard atomA.currentElectronCount < atomA.maxElectronCount,
            atomB.currentElectronCount < atomB.maxElectronCount else {
            return 0
        }

        guard atomA.unpairedElectrons > 0,
              atomB.unpairedElectrons > 0 else {
            return 0
        }
        
        // 조건 3: 필요한 전자 수 계산
        let needA = atomA.maxElectronCount - atomA.currentElectronCount
        let needB = atomB.maxElectronCount - atomB.currentElectronCount

        let maxPossibleBond = min(atomA.unpairedElectrons, atomB.unpairedElectrons)
        let requiredBond = min(needA, needB, 3)

        return min(maxPossibleBond, requiredBond)
    }

    /// 원자의 결합 상태 변화(결합, 결합 전자 수, 홀전자 수 변화)
    /// - Parameters:
    ///   - atomA: 원자 A
    ///   - atomB: 원자 B
    ///   - bond: 몇 중 결합인지 Int 값
    private func changeAtomState(atomA: LabAtom, atomB: LabAtom, bond: Int) {
        atomA.addBond(Bond(atomUUID: atomB.atomId, bondType: bond))
        atomB.addBond(Bond(atomUUID: atomA.atomId, bondType: bond))
    }

    /// 원자의 분자 고유 번호 변화
    /// - Parameters:
    ///   - atom: 원자
    ///   - moleculeUUID: 원자에 분자 id 세팅
    private func changeAtomUUID(atom: LabAtom, moleculeUUID: UUID) {
        atom.setMoleculeId(moleculeUUID)
    }

    /// 분자 안정성 판단
    /// - Parameter molecule: 분자
    /// - Returns: 분자의 안전성 여부 반환
    private func checkMoleculeStable(molecule: LabMolecule) -> Bool {
        for atom in molecule.atoms {
            if atom.unpairedElectrons > 0 || atom.currentElectronCount > atom.maxElectronCount {
                return false
            }
        }
        return true
    }

    /// 분자 생성(원자 2개가 결합할 경우)
    /// - Parameters:
    ///   - atomA: 원자 A
    ///   - atomB: 원자 B
    ///   - bond: 결합 정보 (분자 id, 결합 1, 2, 3 중 무엇인지)
    /// - Returns: 분자
    private func createMolecule(atomA: LabAtom, atomB: LabAtom, bond: Int) -> LabMolecule {
        var bondedA = atomA
        var bondedB = atomB
        bondedA.addBond(Bond(atomUUID: bondedB.atomId, bondType: bond))
        bondedB.addBond(Bond(atomUUID: bondedA.atomId, bondType: bond))
        
        let moleculeUUID = UUID()
        bondedA.setMoleculeId(moleculeUUID)
        bondedB.setMoleculeId(moleculeUUID)
        
        let molecule = LabMolecule(moleculeUUID: moleculeUUID, atoms: [bondedA, bondedB])
        molecule.updateStableStatus(checkMoleculeStable(molecule: molecule))
        
        return molecule
    }

    /// 분자 상태 변화(기존 분자에 새로운 원자 추가)
    /// - Parameters:
    ///   - atom: 원자, 분자
    ///   - molecule: 분자
    private func changeMoleculeState(atom: LabAtom, molecule: LabMolecule) {
        atom.setMoleculeId(molecule.moleculeUUID)
        molecule.addAtom(atom)
        molecule.updateStableStatus(checkMoleculeStable(molecule: molecule))
    }

    /// 분자 상태 변화(분자 두개 한개로 합치기)
    /// - Parameters:
    ///   - moleculeA: 분자, 분자
    ///   - moleculeB: 분자
    private func changeMoleculeState(moleculeA: LabMolecule, moleculeB: LabMolecule) {
        for atom in moleculeB.atoms {
            atom.setMoleculeId(moleculeA.moleculeUUID)
            moleculeA.addAtom(atom)
        }
        
        moleculeA.updateStableStatus(checkMoleculeStable(molecule: moleculeA))
    }
    
    /// 결합 불가능한 경우 처리
    /// - Returns: 에러처리
    private func wrongChoice() -> Void {
        print("결합 불가")
    }

    // 분자 생성
    /// 원자 두개를 받을지, 원자와 분자를 받을지, 분자 두개를 받을 지 상황에 따라 다름

    // 원자 결합
//    func createBondedAtoms(atomA: LabAtom, atomB: LabAtom) -> Void {
//        let bondOrder = predictBondOrder(atomA: atomA, atomB: atomB)
//        if bondOrder == 0 {
//            wrongChoice()
//        }
//        if atomA.moleculeUUID == nil && atomB.moleculeUUID == nil {
//            let molecule = createMolecule(atomA: atomA, atomB: atomB, bond: bondOrder)
//            atomA = changeAtomUUID(atom: atomA, moleculeUUID: molecule.moleculeUUID)
//            atomB = changeAtomUUID(atom: atomB, moleculeUUID: molecule.moleculeUUID)
//            return molecule, atomA, atomB
//        } else if atomA.moleculeUUID == nil && atomB.moleculeUUID != nil {
//            let molecule = createMolecule(atomA: atomA, atomB: atomB, bond: bondOrder)
//            atomA = changeAtomUUID(atom: atomA, moleculeUUID: molecule.moleculeUUID)
//        }else {
//            let molecule = createMolecule(atomA: atomA, atomB: atomB, bond: bondOrder)
//            atomA = changeAtomUUID(atom: atomA, moleculeUUID: molecule.moleculeUUID)
//            atomB = changeAtomUUID(atom: atomB, moleculeUUID: molecule.moleculeUUID)
//        }
//    }
}
