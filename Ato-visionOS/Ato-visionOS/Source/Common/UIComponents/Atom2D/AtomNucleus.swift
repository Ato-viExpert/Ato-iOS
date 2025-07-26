//
//  LabMolecule.swift
//  Ato-visionOS
//
//  Created by bongjooncha on 7/24/25.
//

import SwiftUI

// MARK: - AtomNucleus

/// 원자 핵을 표시하는 뷰
struct AtomNucleus: View {
    // MARK: - Properties

    private let symbol: String
    private let color: Color
    private let size: CGFloat
    
    // MARK: - Init
    
    /// 원자 링
    /// - Parameters:
    ///   - symbol: 원자 기호
    ///   - color: 원자 핵 색상
    ///   - size: 원자 핵 크기
    init(symbol: String, color: Color, size: CGFloat) {
        self.symbol = symbol
        self.color = color
        self.size = size
    }
    
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
