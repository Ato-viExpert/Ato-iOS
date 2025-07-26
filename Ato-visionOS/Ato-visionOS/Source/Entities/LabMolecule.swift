//
//  LabMolecule.swift
//  Ato-visionOS
//
//  Created by bongjooncha on 7/24/25.
//

import Foundation

class LabMolecule{
    // MARK: - Propteries
    
    public let moleculeUUID: UUID /// 분자 고유 번호(동일 분자들과 결합시 구분)
    public private(set) var atoms: [LabAtom] /// 분자의 원자 목록(처음 atom은 1.안정한 원자), 2. 최소 결합을 우선순위)
    public private(set) var stable: Bool? /// 안정한 분자인지 판단
    
    // MARK: - Init
    
    init(moleculeUUID: UUID, atoms: [LabAtom]) {
        self.moleculeUUID = moleculeUUID
        self.atoms = atoms
        self.stable = nil
    }
    
    // MARK: - Public Methods
    
    /// 분자에 원자 추가
    func addAtom(_ atom: LabAtom) {
        atoms.append(atom)
    }
    
    /// 안정성 상태 업데이트
    func updateStableStatus(_ isStable: Bool) {
        self.stable = isStable
    }
}
