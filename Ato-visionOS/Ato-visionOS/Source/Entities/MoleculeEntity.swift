//
//  MoleculeEntity.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import RealityKit
import SwiftUI

/// 두 개의 Bondable 엔티티(원자 또는 분자)를 결합하여 구성된 MoleculeEntity 클래스입니다.
/// 중심 원자는 원점(0, 0, 0)에 위치하고, 주변 원자는 결합 방향에 따라 배치되며, 전체가 하나의 그룹으로 구성됩니다.
/// 결합된 MoleculeEntity는 이동/충돌 등의 상호작용을 위해 입력 및 충돌 컴포넌트를 포함합니다.
final class MoleculeEntity: Entity {
    // MARK: - Init
    
    /// 중심 원자와 주변 원자를 받아 MoleculeEntity를 구성합니다.
    /// 중심 원자는 (0, 0, 0)에 배치되고, 주변 원자는 결합 각도에 따라 위치가 지정됩니다.
    ///
    /// - Parameters:
    ///   - central: 중심이 되는 Bondable 원자
    ///   - peripheral: 결합할 주변 Bondable 원자
    init(central: Bondable, peripheral: Bondable) {
        super.init()
        
        let centralEntity = central as Entity
        centralEntity.position = .zero
        self.addChild(centralEntity)
        
        let bondDirections = BondGeometry.directions(for: central.valenceElectrons)
        
        let direction = bondDirections.first ?? SIMD3<Float>(1, 0, 0)
        let normalized = simd_normalize(direction)
        let distance: Float = 0.06
        let offset = normalized * distance
        
        let peripheralEntity = peripheral as Entity
        peripheralEntity.position = offset
        self.addChild(peripheralEntity)
        
        self.components.set(InputTargetComponent())
        self.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

// MARK: - Bondable protocol

extension MoleculeEntity: Bondable {
    var type: AtomType {
        centralBondable?.type ?? .H
    }
    
    var bondsRemaining: Int {
        get { centralBondable?.bondsRemaining ?? 0 }
        set { centralBondable?.bondsRemaining = newValue }
    }
    
    var bondsUsed: Int {
        get { centralBondable?.bondsUsed ?? 0 }
        set { centralBondable?.bondsUsed = newValue }
    }
    
    var symbol: String {
        centralBondable?.symbol ?? "?"
    }
    
    var valenceElectrons: Int {
        centralBondable?.valenceElectrons ?? 0
    }
    
    var entity: Entity { self }
    
    private var centralBondable: Bondable? {
        children.compactMap { $0 as? Bondable }.first
    }
}
