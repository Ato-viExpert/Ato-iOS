//
//  LabAtom.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/24/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Bond{
    let atomUUID: UUID /// 결합 상대 원자 고유 번호
    let bondType: Int /// 몇 중 결합인지(1, 2, 3)
}

class LabAtom: Atom {
    // MARK: - Propteries
    
    public let atomId = UUID() /// 원자 고유 번호(동일 원자들과 결합시 구분)
    public private(set) var moleculeId: UUID? /// 분자 고유 번호(동일 분자들과 결합시 구분)
    
    public private(set) var sharedElectrons: Int = 0 /// 결합 전자 수
    public private(set) var bonds: [Bond] = [] /// 현재 결합 정보들
    public var currentElectronCount: Int { /// 현재 전자 수
        return sharedElectrons + unpairedElectrons
    }
    public var unpairedElectrons: Int { /// 홀전자 수(결합 가능한 전자 수)
        return maxElectronCount - sharedElectrons
    }
    public private(set) var maxElectronCount: Int
    
    private let diffuseColor: UIColor /// 확산 색상
    private let emissiveColor: UIColor /// 발광 색상
    private let modelScale: Float /// 모델 크기
    private(set) var entity: Entity?
    
    // MARK: - Init
    
    init(
        atomicNumber: Int
    ) {
        guard let atomType = AtomType.from(atomicNumber: atomicNumber) else {
            fatalError("Invalid atomic number: \(atomicNumber)")
        }
        
        self.maxElectronCount = atomType.orbit == 1 ? 2 : 8
        self.diffuseColor = atomType.diffuseColor
        self.emissiveColor = atomType.emissiveColor
        self.modelScale = atomType.modelScale
        super.init(
            atomicNumber: atomicNumber,
            symbol: atomType.symbol,
            electronShells: atomType.electronsPerOrbit
        )
    }
    
    // MARK: - Public Methods
    
    /// 분자 아이디 설정
    func setMoleculeId(_ id: UUID) {
        self.moleculeId = id
    }
    
    /// 공유 전자 수 증가
    func increaseSharedElectrons(by amount: Int) {
        sharedElectrons += amount
    }
    
    /// 공유 전자 수 감소
    func decreaseSharedElectrons(by amount: Int) {
        sharedElectrons = max(0, sharedElectrons - amount)
    }
    
    /// 결합 추가
    func addBond(_ bond: Bond) {
        guard !bonds.contains(where: { $0.atomUUID == bond.atomUUID }) else { return }
        bonds.append(bond)
        increaseSharedElectrons(by: bond.bondType * 2)
    }
    
    /// 결합 제거
    func removeBond(_ bond: Bond) {
        if let index = bonds.firstIndex(where: { $0.atomUUID == bond.atomUUID }) {
            let removedBond = bonds[index]
            bonds.remove(at: index)
            decreaseSharedElectrons(by: removedBond.bondType * 2)
        }
    }
    
    /// 모든 결합 제거
    func clearBonds() {
        bonds.removeAll()
        sharedElectrons = 0
    }
}

extension LabAtom {
    // MARK: - 3D 원자 로드 Methods
    
    /// 주어진 LabAtom의 속성(심볼, 스케일 등)을 기반으로 RealityKit 엔티티를 비동기적으로 로드하고 설정합니다.
    /// - Returns: 설정이 완료된 RealityKit 엔티티
    func loadEntity() async throws -> Entity {
        if let existing = entity {
            return existing
        }
        let root = try await Entity(named: symbol, in: realityKitContentBundle)
        
        await MainActor.run {
            root.scale = SIMD3<Float>(repeating: modelScale)
            
            let bounds = root.visualBounds(relativeTo: nil)
            let shape = ShapeResource.generateBox(size: bounds.extents)
            root.components.set(CollisionComponent(shapes: [shape]))
            root.components.set(InputTargetComponent())
        }

        self.entity = root
        return root
    }
}
