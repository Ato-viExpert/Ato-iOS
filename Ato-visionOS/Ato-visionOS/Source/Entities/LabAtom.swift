//
//  LabAtom.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/24/25.
//

import SwiftUI
import RealityKit

struct Bond{
    let atomUUID: UUID /// 결합 상대 원자 고유 번호
    let bondType: Int /// 몇 중 결합인지(1, 2, 3)
}

class LabAtom: Atom {
    // MARK: - Propteries
    
    private let moleculeUUID: UUID? /// 분자 고유 번호(동일 분자들과 결합시 구분)
    private let atomUUID: UUID /// 원자 고유 번호(동일 원자들과 결합시 구분)
    private let period: Int /// 주기(1주기는 2가 최대, 2주기 이상 부터는 8이 최대로 알고리즘 작성)
    private let outerElement: Int /// 최외각 전자 수

    private var sharedElectrons: Int = 0 /// 결합 전자 수
    private var unpairedElectrons: Int { /// 홀전자 수(결합 가능한 전자 수)
        return maxElectronCount - sharedElectrons
    } 
    private var bonds: [Bond] = [] /// 결합 정보
    private let diffuseColor: UIColor /// 확산 색상
    private let emissiveColor: UIColor /// 발광 색상
    private let modelScale: Float /// 모델 크기
    
    // MARK: - Init
    
    init(
        moleculeUUID: UUID?,
        atomUUID: UUID,
        period: Int,
        outerElement: Int,
        diffuseColor: UIColor,
        emissiveColor: UIColor,
        modelScale: Float,
        sharedElectrons: Int = 0,
        bonds: [Bond] = []
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
