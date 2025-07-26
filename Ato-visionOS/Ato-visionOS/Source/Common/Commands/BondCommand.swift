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
