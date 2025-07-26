//
//  LabView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/26/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct LabView: View {
    
    // MARK: - Properties
    
    @Environment(AppModel.self) private var appModel
    @State private var initialPosition: SIMD3<Float>? = nil
    
    // MARK: - Body
    
    var body: some View {
        RealityView { content in
            appModel.realityContent = content
        } update: { content in
            for entity in content.entities {
                if entity.components[PhysicsBodyComponent.self] == nil {
                    
                    let physics = PhysicsBodyComponent(
                        massProperties: .default,
                        material: .default,
                        mode: .kinematic
                    )
                    entity.components.set(physics)
                }
            }
        }
        .gesture(appModel.selectedTool == .move ? dragGesture : nil)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if initialPosition == nil {
                    initialPosition = entity.position
                }
                let movement = value.convert(value.translation3D, from: .global, to: .scene)
                entity.position = (initialPosition ?? .zero) + movement.grounded
            }
            .onEnded { _ in
                initialPosition = nil
            }
    }
}

#Preview(windowStyle: .volumetric) {
    LabView()
        .environment(AppModel())
}
