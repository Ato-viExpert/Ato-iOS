//
//  ToggleImmersiveSpaceButton.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//

import SwiftUI

struct ToggleImmersiveSpaceButton: View {
    @Environment(AppModel.self) private var appModel
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace

    var body: some View {
        Toggle(isOn: Binding(
            get: { appModel.immersiveSpaceState == .open },
            set: { newValue in
                Task { @MainActor in
                    if newValue {
                        if appModel.immersiveSpaceState == .closed {
                            appModel.immersiveSpaceState = .inTransition
                            switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
                            case .opened:
                                break
                            case .userCancelled, .error:
                                fallthrough
                            @unknown default:
                                appModel.immersiveSpaceState = .closed
                            }
                        }
                    } else {
                        if appModel.immersiveSpaceState == .open {
                            appModel.immersiveSpaceState = .inTransition
                            await dismissImmersiveSpace()
                        }
                    }
                }
            }
        )) {
            Text("가상 환경")
        }
        .toggleStyle(.switch)  // 스위치 스타일로 변경
        .tint(.blue)          // 토글이 ON일 때의 색상
        .disabled(appModel.immersiveSpaceState == .inTransition)
        .animation(.none, value: 0)
        .fontWeight(.semibold)
    }
}