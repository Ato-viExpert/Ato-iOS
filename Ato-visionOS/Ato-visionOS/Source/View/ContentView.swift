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
    @State private var splitSize: CGSize = CGSize(width: 1200, height: 800)

    
    var body: some View {
        ZStack(alignment: .bottom) {
            SplitPeriodicView()
                .padding()
                .frame(minWidth: 900, minHeight: 600)
//                .fixedSize()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
    //            .bg()
                .clipShape(RoundedRectangle(cornerRadius: 55))
                .padding(.bottom, 35)
                .onPreferenceChange(SplitViewWindowSizeKey.self) { newSize in
                    splitSize = newSize
                }
                
            
            ToolbarView(containerSize: splitSize)
                .frame(width: 300, height: 80)
                .background(Color.red)
//                .aspectRatio(contentMode: .fit)
//                .padding(.horizontal, 305)
        }
        .frame(minWidth: 1250, minHeight: 650)
    }
}


#Preview(windowStyle: .plain) {
    ContentView()
        .environment(AppModel())
}

