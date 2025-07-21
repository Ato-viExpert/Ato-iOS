//
//  Command.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import SwiftUI
import RealityKit

/// 모든 커맨드가 준수해야 하는 공통 인터페이스입니다.
/// 실행(redo 포함)과 실행 취소(undo)를 정의하여 커맨드 패턴을 구현합니다.
protocol Command {
    /// 커맨드를 실행합니다.
    /// - Parameter content: 커맨드가 적용될 RealityView의 콘텐츠입니다.
    /// - Returns: 커맨드 실행 결과 (`CommandResult`)를 반환합니다.
    /// - Throws: 실행 도중 오류가 발생할 수 있습니다.
    func execute(in content: RealityViewContent) async throws -> CommandResult
    
    /// 커맨드 실행을 취소(undo)합니다.
    /// - Parameter content: undo 작업이 적용될 RealityView의 콘텐츠입니다.
    /// - Returns: Undo 결과 (`CommandResult`)를 반환합니다.
    /// - Throws: 실행 취소 도중 오류가 발생할 수 있습니다.
    func undo(in content: RealityViewContent) async throws -> CommandResult
}
