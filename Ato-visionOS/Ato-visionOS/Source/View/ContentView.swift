//
//  ContentView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        ZStack(alignment: .bottom) {
            SplitPeriodicView()
            .padding()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .bg()
            .clipShape(RoundedRectangle(cornerRadius: 55))
            .padding(.bottom, 35)
            
            
            ToolbarView()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 305)
        }
    }
}


#Preview(windowStyle: .plain) {
    ContentView()
        .environment(AppModel())
}
