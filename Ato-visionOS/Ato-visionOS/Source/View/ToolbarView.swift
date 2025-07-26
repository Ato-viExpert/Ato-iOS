//
//  ToolbarView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/18/25.
//

import SwiftUI

struct ToolbarView: View {
    // MARK: - Properties
    let width: CGFloat
    let height: CGFloat
    private let tools = ToolType.allCases
    
    // MARK: - Body

    var body: some View {

        HStack(spacing: width * 0.03) {
            ForEach(Array(tools.enumerated()), id: \.1) { index, tool in
                if index > 0 && tools[index - 1].group != tool.group {
                    Divider()
                        .frame(height: height * 0.05)
                }

                ToolbarIconButton(tool: tool)
                    .frame(width: height * 0.05, height: height * 0.05)
            }
        }
        .frame(width: max(width * 0.42, 610), height: max(height * 0.08, 65))
//        .onChange(of: width) {
//            print("width * 0.42:\(width * 0.42)") //617.8199999999999
//            print("height * 0.08:\(height * 0.08)")//66
//        }
        .bg()
        .clipShape(Capsule())

    }
}

/// 툴 바 버튼
fileprivate struct ToolbarIconButton: View {
    @Environment(AppModel.self) private var appModel
    let tool: ToolType
    
    var body: some View {
        Button {
            if tool.group == .selectable {
                appModel.selectedTool = tool
            } else {
                //TODO: - 되돌아가기, 실행취소 실행
            }
        } label: {
            //TODO: - 되돌아가기, 실행취소 할게 있을때 색상 변경
            Image(tool.icon)
                .resizable()
                .scaledToFit()
        }
        .buttonStyle(.plain)
        .background((appModel.selectedTool == tool) ? .white.opacity(0.36) : .clear)
        .clipShape(
            Circle()
        )
    }
}

#Preview(windowStyle: .plain) {
    ToolbarView(width: 1000, height: 800)
        .environment(AppModel())
}
