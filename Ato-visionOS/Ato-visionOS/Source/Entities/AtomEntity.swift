//
//  AtomEntity.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import RealityKit
import RealityKitContent

/// 주어진 AtomInstance를 기반으로 RealityKit 상에 원자(Atom)를 표현하는 엔티티입니다.
/// 외부에서 생성한 3D 원자 모델(.usdc)을 불러오고, 위치 및 충돌 설정과 입력 타겟 컴포넌트를 구성합니다.
final class AtomEntity: Entity {
    
    // MARK: - Properties
    
    var instance: AtomInstance
    
    // MARK: - Init
    
    /// AtomInstance로부터 AtomEntity를 생성합니다.
    /// - Parameter instance: 생성할 원자의 타입 및 위치 정보를 담은 인스턴스
    init(instance: AtomInstance) async throws {
        self.instance = instance
        super.init()
        
        let symbol = instance.type.rawValue
        let rootEntity = try await Entity(named: symbol, in: realityKitContentBundle)
        
        let targetRadius = instance.type.modelScale
        // TODO: - 작은 원자 받은 후 크기 비율 변화 필요
        rootEntity.scale = [1.0, 1.0, 1.0]
        rootEntity.position = instance.position
        
        let shape = ShapeResource.generateSphere(radius: targetRadius)
        self.components.set(CollisionComponent(shapes: [shape]))
        self.components.set(InputTargetComponent())
        
        self.addChild(rootEntity)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    // MARK: - Methods
    
    /// 엔티티 트리에서 특정 이름을 가진 ModelEntity를 재귀적으로 탐색합니다.
    /// - Parameters:
    ///   - targetName: 찾고자 하는 모델의 이름
    ///   - entity: 탐색할 루트 엔티티
    /// - Returns: 이름이 일치하는 ModelEntity 또는 nil
    private func findModelEntity(named targetName: String, in entity: Entity) -> ModelEntity? {
        if let model = entity as? ModelEntity, model.name == targetName {
            return model
        }
        for child in entity.children {
            if let found = findModelEntity(named: targetName, in: child) {
                return found
            }
        }
        return nil
    }
}

// MARK: - Bondable protocol

extension AtomEntity: Bondable {
    var type: AtomType { instance.type }
    
    var bondsRemaining: Int {
        get { instance.bondsRemaining }
        set { instance.bondsRemaining = newValue }
    }
    
    var bondsUsed: Int {
        get { instance.bondsUsed }
        set { instance.bondsUsed = newValue }
    }
    
    var symbol: String { instance.type.symbol }
    
    var valenceElectrons: Int { instance.type.valenceElectrons }
    
    var entity: Entity { self }
}
