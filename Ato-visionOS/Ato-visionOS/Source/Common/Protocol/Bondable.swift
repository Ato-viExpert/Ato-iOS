//
//  Bondable.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import RealityFoundation

protocol Bondable: Entity {
    var type: AtomType { get }
    var bondsRemaining: Int { get set }
    var bondsUsed: Int { get set }
    var symbol: String { get }
    var entity: Entity { get }
    var valenceElectrons: Int { get }
}
