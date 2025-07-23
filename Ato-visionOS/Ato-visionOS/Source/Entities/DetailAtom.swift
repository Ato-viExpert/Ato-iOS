//
//  DetailAtom.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/23/25.
//

import SwiftUI
import RealityKit

class DetailAtom: Atom {
    // MARK: - Propteries
    
    private let name: String
    private let color: Color
    private let description: String
    
    // MARK: - Init
    
    init(
        atomicNumber: Int,
        symbol: String,
        electronShells: [Int],
        name: String,
        color: Color,
        description: String
    ) {
        let atomType = AtomType.from(atomicNumber: atomicNumber)
        self.name = name
        self.color = Color(atomType?.diffuseColor ?? .white)
        self.description = description
        super.init(atomicNumber: atomicNumber, symbol: symbol, electronShells: electronShells)
    }
}
