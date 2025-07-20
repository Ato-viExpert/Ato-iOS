//
//  ToolType.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import SwiftUI

enum ToolGroup {
    case selectable, action
}

enum ToolType: CaseIterable, Equatable {
    case move // 이동
    case magnify // 돋보기(확대)
    case bond // 원자 결합
    case dissociate // 분자 분해
    case erase // 지우개
    case undo // 되돌리기
    case redo // 되돌리기 취소
    
    var group: ToolGroup {
        switch self {
        case .undo, .redo: return .action
        default: return .selectable
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .move:
            return .icMove
        case .magnify:
            return .icObserve
        case .bond:
            return .icConnet
        case .dissociate:
            return .icDisconnect
        case .erase:
            return .icDelete
        case .undo:
            return .icNext
        case .redo:
            return .icBack
        }
    }
}
