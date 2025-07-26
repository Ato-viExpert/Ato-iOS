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
            
            content.add(existingEntity)
            
            return .entity(existingEntity)
        }
        let instance = AtomInstance(type: atomType)
        let atomEntity = try await AtomEntity(instance: instance)
        spawnedEntity = atomEntity
        
        content.add(atomEntity)
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
