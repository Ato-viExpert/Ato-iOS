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
    
    private let id = UUID()
    private let diffuseColor: UIColor
    private let emissiveColor: UIColor
    private let modelScale: Float
    private(set) var entity: Entity?
    
    // MARK: - Init
    
    init(
        atomicNumber: Int
    ) {
        guard let atomType = AtomType.from(atomicNumber: atomicNumber) else {
            fatalError("Invalid atomic number: \(atomicNumber)")
        }
        
        self.diffuseColor = atomType.diffuseColor
        self.emissiveColor = atomType.emissiveColor
        self.modelScale = atomType.modelScale
        super.init(
            atomicNumber: atomicNumber,
            symbol: atomType.symbol,
            electronShells: atomType.electronsPerOrbit
        )
    }
    
    // MARK: - Methods
    
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
