import SwiftUI

// MARK: - AtomNucleus

/// 원자 핵을 표시하는 뷰

struct AtomNucleus: View {
    // MARK: - Properties

    /// - Parameters:
    ///   - symbol: 원자 기호
    ///   - color: 원자 핵 색상
    ///   - size: 원자 핵 크기
    let symbol: String
    let color: Color
    let size: CGFloat

    // MARK: - Body
    var body: some View {
        Text(symbol)
            .font(.system(size: size * 0.2, weight: .bold))
            .foregroundColor(.white)
            .padding(20)
            .background(
                Circle()
                    .fill(color)
            )
    }
}