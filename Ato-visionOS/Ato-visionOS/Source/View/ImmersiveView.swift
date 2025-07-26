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
    @State private var selectedBondables: [Bondable] = []
    
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
    
    var tapGesture: some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                guard let content = appModel.realityContent else { return }
                
                let entity = value.entity
                
                switch appModel.selectedTool {
                case .bond:
                    if let bondable = entity as? Bondable {
                        selectedBondables.append(bondable)
                        
                        if selectedBondables.count == 2 {
                            let first = selectedBondables[0]
                            let second = selectedBondables[1]
                            
                            Task {
                                let command = BondCommand(first: first, second: second)
                                _ = await appModel.commandManager.execute(command, in: content)
                            }
                            
                            selectedBondables.removeAll()
                        }
                    }
                case .dissociate:
                    if let molecule = entity as? MoleculeEntity {
                        Task {
                            let command = DissociateCommand(target: molecule)
                            _ = await appModel.commandManager.execute(command, in: content)
                        }
                    }
                default:
                    break
                }
            }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
