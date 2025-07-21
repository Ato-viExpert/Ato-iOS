//
//  CommandManager.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import SwiftUI
import RealityKit

/// 사용자의 명령(Command)을 실행하고, 실행 취소(Undo) 및 다시 실행(Redo) 기능을 제공하는 매니저 클래스입니다.
/// RealityKit 환경에서 비동기 커맨드 실행을 관리하며 최대 Undo 기록 수를 제한합니다.
@Observable
final class CommandManager {
    // MARK: - Properties
    
    private var undoStack: [any Command] = []
    private var redoStack: [any Command] = []
    
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    
    private let maxUndoStackSize = 30
    
    // MARK: - Methods

    /// 새로운 커맨드를 실행하고 Undo 스택에 저장합니다.
    /// - Parameters:
    ///   - command: 실행할 커맨드 객체입니다.
    ///   - content: 커맨드가 적용될 RealityView의 콘텐츠입니다.
    /// - Returns: 커맨드 실행 결과(CommandResult)를 반환합니다.
    @discardableResult
    func execute(_ command: some Command, in content: RealityViewContent) async -> CommandResult {
        do {
            let result = try await command.execute(in: content)
            
            if undoStack.count >= maxUndoStackSize {
                undoStack.removeFirst()
            }
            
            undoStack.append(command)
            redoStack.removeAll()
            return result
        } catch {
            print("⚠️ 커맨드 실행 실패: \(error)")
            return .none
        }
    }

    /// 마지막으로 실행한 커맨드를 실행 취소합니다.
    /// - Parameter content: 실행 취소를 적용할 RealityView 콘텐츠입니다.
    /// - Returns: Undo 결과(CommandResult)를 반환합니다.
    @discardableResult
    func undo(in content: RealityViewContent) async -> CommandResult {
        guard let command = undoStack.popLast() else { return .none }
        do {
            let result = try await command.undo(in: content)
            redoStack.append(command)
            return result
        } catch {
            print("⚠️ undo 실패: \(error)")
            return .none
        }
    }

    /// 마지막으로 Undo한 커맨드를 다시 실행합니다.
    /// - Parameter content: 다시 실행을 적용할 RealityView 콘텐츠입니다.
    /// - Returns: Redo 결과(CommandResult)를 반환합니다.
    @discardableResult
    func redo(in content: RealityViewContent) async -> CommandResult {
        guard let command = redoStack.popLast() else { return .none }
        do {
            let result = try await command.execute(in: content)
            undoStack.append(command)
            return result
        } catch {
            print("⚠️ redo 실패: \(error)")
            return .none
        }
    }

    /// Undo 및 Redo 스택을 모두 초기화합니다.
    func reset() {
        undoStack.removeAll()
        redoStack.removeAll()
    }
}
