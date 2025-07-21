//
//  CommandResult.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import RealityFoundation

/// 커맨드 실행 결과를 나타내는 열거형입니다.
/// 커맨드가 수행한 작업의 결과로 반환되는 Entity 또는 상태를 표현합니다.
enum CommandResult {
    case none /// 결과가 없는 경우 (예: 실패, 아무 작업도 수행되지 않음)
    case entity(Entity)  /// 단일 Entity를 반환하는 경우 (예: 하나의 오브젝트 생성, 선택 등)
    case entities([Entity]) /// 복수의 Entity를 반환하는 경우 (예: 다중 선택, 그룹 삭제 등)
}
