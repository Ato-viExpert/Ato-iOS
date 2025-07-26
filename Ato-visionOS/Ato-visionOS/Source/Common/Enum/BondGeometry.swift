//
//  BondGeometry.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import Foundation
import RealityKit

/// `BondGeometry`는 원자의 최외각 전자 수(=결합 가능한 수)를 기반으로, VSEPR 이론을 근거로 한 결합 방향 벡터를 제공하는 유틸리티입니다.
/// 이 방향 벡터는 3D 공간에서 분자의 기하학적 구조를 구성할 때 사용됩니다.
enum BondGeometry {
    
    /// 주어진 원자의 최외각 전자 수에 따라 결합 가능한 방향 벡터를 반환합니다.
    /// 이 벡터들은 중심 원자 기준의 상대적 방향이며, 분자 구조의 입체 배치를 결정합니다.
    /// - Parameter valenceElectrons: 결합 가능한 전자 수 (보통 1~6)
    /// - Returns: 결합 방향을 나타내는 3D 벡터들의 배열
    static func directions(for valenceElectrons: Int) -> [SIMD3<Float>] {
        switch valenceElectrons {
        case 2:
            return [
                SIMD3<Float>(1, 0, 0),
                SIMD3<Float>(-1, 0, 0)
            ]
        case 3:
            return [
                SIMD3<Float>(1, 0, 0),
                SIMD3<Float>(-0.5, 0, 0.866),
                SIMD3<Float>(-0.5, 0, -0.866)
            ]
        case 4:
            return [
                normalize(SIMD3<Float>(1, 1, 1)),
                normalize(SIMD3<Float>(-1, -1, 1)),
                normalize(SIMD3<Float>(-1, 1, -1)),
                normalize(SIMD3<Float>(1, -1, -1))
            ]
        case 5:
            return [
                SIMD3<Float>(1, 0, 0),
                SIMD3<Float>(-1, 0, 0),
                SIMD3<Float>(0, 1, 0),
                SIMD3<Float>(0, -1, 0),
                SIMD3<Float>(0, 0, 1)
            ]
        case 6:
            return [
                SIMD3<Float>(1, 0, 0),
                SIMD3<Float>(-1, 0, 0),
                SIMD3<Float>(0, 1, 0),
                SIMD3<Float>(0, -1, 0),
                SIMD3<Float>(0, 0, 1),
                SIMD3<Float>(0, 0, -1)
            ]
        default:
            return [SIMD3<Float>(1, 0, 0)]
        }
    }
}
