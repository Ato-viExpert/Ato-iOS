//
//  ImmersiveView.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/15/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    // MARK: - Properties
    
    @Environment(AppModel.self) private var appModel
    @State private var initialPosition: SIMD3<Float>? = nil
    
    // MARK: - Body
    
    var body: some View {
        RealityView { content in
            if content.entities.first(where: { $0.name == "main-anchor" }) == nil {
                let anchor = AnchorEntity(world: [0, 1, -1])
                anchor.name = "main-anchor"
                content.add(anchor)
                appModel.realityContent = content
                
            }
        } update: { content in
            for entity in content.entities {
                if let atom = entity as? AtomEntity,
                   atom.components[PhysicsBodyComponent.self] == nil {
                    
                    let physics = PhysicsBodyComponent(
                        massProperties: .default,
                        material: .default,
                        mode: .kinematic
                    )
                    
                    atom.components.set(physics)
                }
            }
        }
        .gesture(appModel.selectedTool == .move ? dragGesture : nil)
        .ignoresSafeArea()
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

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
