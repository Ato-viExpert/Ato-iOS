//
//  AtomInstance.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import Foundation

struct AtomInstance: Identifiable {
    let id = UUID()
    let type: AtomType
    var bondsUsed: Int = 0
    var bondsRemaining: Int
    var position: SIMD3<Float> = .zero
    
    init(type: AtomType) {
        self.type = type
        self.bondsRemaining = type.valenceElectrons
    }
}
