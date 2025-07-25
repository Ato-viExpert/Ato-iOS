//
//  Ato_visionOSApp.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//

import SwiftUI

@main
struct Ato_visionOSApp: App {
    
    @State private var appModel = AppModel()
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .frame(minWidth: 1300, minHeight: 700)
                .environment(appModel)
                .task {
                    await openImmersiveSpace(id: appModel.immersiveSpaceID)
                }
        }
        .windowStyle(.plain)
//        .defaultSize(width: .infinity, height: .infinity)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
