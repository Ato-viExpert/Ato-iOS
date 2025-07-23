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
    private let diffuseColor: UIColor
    private let emissiveColor: UIColor
    private let modelScale: Float
    
    // MARK: - Init
    
    init(
        atomicNumber: Int,
        symbol: String,
        electronShells: [Int],
        diffuseColor: UIColor,
        emissiveColor: UIColor,
        modelScale: Float
    ) {
        guard let atomType = AtomType.from(atomicNumber: atomicNumber) else {
            fatalError("Invalid atomic number: \(atomicNumber)")
        }
        
//        let atomType = AtomType.from(atomicNumber: atomicNumber)
        self.diffuseColor = atomType.diffuseColor
        self.emissiveColor = atomType.emissiveColor
        self.modelScale = atomType.modelScale
        super.init(atomicNumber: atomicNumber, symbol: symbol, electronShells: electronShells)
    }
}
