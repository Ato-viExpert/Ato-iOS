import Foundation

struct MoleculeEntity{
    private let moleculeUUID: UUID /// 분자 고유 번호(동일 분자들과 결합시 구분)
    private let atoms: [LabAtomEntity] /// 분자의 원자 목록(처음 atom은 1.안정한 원자), 2. 최소 결합을 우선순위)
    private let stable: Bool = false /// 안정한 분자인지 판단

    init(moleculeUUID: UUID, atoms: [LabAtomEntity], stable: Bool) {
        self.moleculeUUID = moleculeUUID
        self.atoms = atoms
        self.stable = stable
    }
}