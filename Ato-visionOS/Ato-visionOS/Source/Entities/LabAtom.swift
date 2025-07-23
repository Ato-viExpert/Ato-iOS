//
//  LabAtom.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/24/25.
//

import SwiftUI
import RealityKit

class LabAtom: Atom {
    // MARK: - Propteries
    
    private let id = UUID()
    private let color1: Color
    private let color2: Color
    private let size: Int
    
    // MARK: - Init
    
    init(
        atomicNumber: Int,
        symbol: String,
        electronShells: [Int],
        color1: Color,
        color2: Color,
        size: Int
    ) {
        let atomType = AtomType.from(atomicNumber: atomicNumber)
        self.color1 = color1
        self.color2 = color2
        self.size = size
        super.init(atomicNumber: atomicNumber, symbol: symbol, electronShells: electronShells)
    }
}
