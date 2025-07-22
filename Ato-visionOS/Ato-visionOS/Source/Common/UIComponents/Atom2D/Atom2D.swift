import SwiftUI

// MARK: - Atom2D

/// 원자 2D 뷰

struct Atom2D: View {
    // MARK: - Properties

    // MARK: - Properties

    private let atomType: AtomType
    private let size: CGFloat
    private var atomColor: Color {
        Color(uiColor: atomType.diffuseColor)
    }
    
    /// Atom2D
    /// - Parameters:
    ///   - atomType: 원자 종류
    ///   - size: 전반적 크기
    init(atomType: AtomType, size: CGFloat) {
        self.atomType = atomType
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // MARK: - 원자핵
            AtomNucleus(
                symbol: atomType.symbol,
                color: atomColor,
                size: size
            )
            // MARK: - 전자 껍질
            AtomOrbit(
                electronsPerOrbit: atomType.electronsPerOrbit,
                size: size
            )
        }
    }
}


#Preview {
    HStack(spacing: 20) {
        Atom2D(atomType: .I, size: 100)
        Atom2D(atomType: .H, size: 100)
        Atom2D(atomType: .O, size: 100)
        Atom2D(atomType: .C, size: 100)
    }
}
