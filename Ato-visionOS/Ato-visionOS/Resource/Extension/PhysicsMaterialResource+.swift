//
//  PhysicsMaterialResource+.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import RealityFoundation

extension PhysicsMaterialResource {
    static let atomMaterial = PhysicsMaterialResource.generate(
        staticFriction: 0.5,
        dynamicFriction: 0.5,
        restitution: 0.3
    )
}
