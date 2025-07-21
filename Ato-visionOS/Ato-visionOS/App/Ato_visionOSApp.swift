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
                .environment(appModel)
                .task {
                    await openImmersiveSpace(id: appModel.immersiveSpaceID)
                }
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
