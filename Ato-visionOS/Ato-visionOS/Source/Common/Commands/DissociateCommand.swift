//
//  DissociateCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import RealityKit
import SwiftUI

/// `DissociateCommand`는 결합된 `MoleculeEntity`를 분리하여 각 구성 원자들을 독립적인 엔티티로 되돌리는 커맨드입니다.
/// Command 패턴을 따르며, undo 시에는 다시 하나의 분자로 복원합니다.
final class DissociateCommand: Command {
    // MARK: - Properties
    
    private let target: MoleculeEntity
    private var separatedEntities: [Entity] = []
    
    // MARK: - Init
    
    /// DissociateCommand 생성자
    /// - Parameter target: 해체할 대상 `MoleculeEntity`
    init(target: MoleculeEntity) {
        self.target = target
    }
    
    // MARK: - Methods
    
    /// 결합된 분자를 해체하여 개별 원자 엔티티로 변환합니다.
    /// - Parameter content: RealityViewContent 내부에 있는 엔티티 컨테이너
    /// - Returns: 해체된 엔티티들의 배열을 포함한 `CommandResult`
    func execute(in content: RealityViewContent) async throws -> CommandResult {
        let childrenToSeparate = await target.children
        
        for child in childrenToSeparate {
            await target.removeChild(child)
            await MainActor.run {
                child.position += target.position
            }
            content.add(child)
            separatedEntities.append(child)
        }
        
        content.remove(target)
        return .entities(separatedEntities)
    }
    
    /// 실행 취소 시, 다시 하나의 MoleculeEntity로 결합합니다.
    /// - Parameter content: RealityViewContent 컨텍스트
    /// - Returns: 복원된 MoleculeEntity를 포함한 `CommandResult`
    func undo(in content: RealityViewContent) async throws -> CommandResult {
        let newMolecule = await MoleculeEntity()
        for entity in separatedEntities {
            content.remove(entity)
            await MainActor.run {
                entity.position -= target.position
            }
            await newMolecule.addChild(entity)
        }
        
        newMolecule.position = await target.position
        content.add(newMolecule)
        return .entity(newMolecule)
    }
}
