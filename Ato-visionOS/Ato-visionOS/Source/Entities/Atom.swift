//
//  Atom.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/23/25.
//

class Atom {
    // MARK: - Propteries
    
    private(set) var atomicNumber: Int
    private(set) var symbol: String
    private(set) var electronShells: [Int]
    
    // MARK: - Init
    
    init(atomicNumber: Int, symbol: String, electronShells: [Int]) {
        self.atomicNumber = atomicNumber
        self.symbol = symbol
        self.electronShells = electronShells
    }
}
