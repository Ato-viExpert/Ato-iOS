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
    var body: some View {
        RealityView { content in
            if let immersiveContentEntity = try? await Entity(named: "ImmersiveSpace.usda", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
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

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
