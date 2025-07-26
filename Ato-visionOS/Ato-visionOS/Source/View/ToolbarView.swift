//
//  ToolbarView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import SwiftUI

struct ToolbarView: View {
    // MARK: - Properties
    
    private let baseWidth: CGFloat = 450
    private let baseHeight: CGFloat = 69
    private let tools = ToolType.allCases
    
    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            let widthRatio = geo.size.width / baseWidth
            let heightRatio = geo.size.height / baseHeight

            HStack(spacing: 16 * widthRatio) {
                ForEach(Array(tools.enumerated()), id: \.1) { index, tool in
                    if index > 0 && tools[index - 1].group != tool.group {
                        Rectangle()
                            .background(Color.secondary)
                            .frame(width: 1 * widthRatio, height: 24 * heightRatio)
                    }

                    ToolbarIconButton(tool: tool)
                        .frame(width: 44 * widthRatio, height: 44 * heightRatio)
                }
            }
            .padding(.horizontal, 48 * widthRatio)
            .padding(.vertical, 16 * heightRatio)
            .frame(width: geo.size.width, height: geo.size.height)
            .bg()
            .clipShape(Capsule())
        }
        .frame(minWidth: baseWidth, minHeight: baseHeight)
    }
}


/// 툴 바 버튼
fileprivate struct ToolbarIconButton: View {
    @Environment(AppModel.self) private var appModel
    let tool: ToolType
    
    var body: some View {
        Button (action: handleButtonTap) {
            Image(tool.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(iconColor)
        }
        .buttonStyle(.plain)
        .background((appModel.selectedTool == tool) ? .white.opacity(0.36) : .clear)
        .clipShape(
            Circle()
            
        )
    }
    
    private func handleButtonTap() {
        if tool.group == .selectable {
            appModel.selectedTool = tool
        } else {
            guard let content = appModel.realityContent else { return }
            
            switch tool {
            case .undo:
                Task {
                    _ = await appModel.commandManager.undo(in: content)
                }
            case .redo:
                Task {
                    _ = await appModel.commandManager.redo(in: content)
                }
            default:
                break
            }
        }
    }
    
    private var iconColor: Color {
        switch tool {
        case .undo:
            return appModel.commandManager.canUndo ? .white.opacity(1.0) : .gray
        case .redo:
            return appModel.commandManager.canRedo ? .white : .gray
        default:
            return .white
        }
    }
}

#Preview(windowStyle: .plain) {
    ToolbarView()
        .environment(AppModel())
}
