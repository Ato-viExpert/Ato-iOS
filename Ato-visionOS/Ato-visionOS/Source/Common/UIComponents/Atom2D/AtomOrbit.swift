import SwiftUI

// MARK: - Electron

/// 전자를 표시하는 뷰

struct Electron: View {
    // MARK: - Body
    var body: some View {
        Circle()
            .fill(.red)
            .frame(width: 10, height: 10)
            .overlay(
                Circle()
                    .strokeBorder(.white, lineWidth: 1)
            )
    }
}

// MARK: - AtomOrbit

/// 전자 껍질을 표시하는 뷰

struct AtomOrbit: View {
    // MARK: - Properties

    /// - Parameters:
    ///   - electronsPerOrbit: 각 궤도의 전자 수
    ///   - size: 전반적 크기
    let electronsPerOrbit: [Int]
    let size: CGFloat
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - 각 궤도 그리기
            ForEach(0..<electronsPerOrbit.count, id: \.self) { orbitIndex in
                let orbitRadius = size * (1 + Double(orbitIndex) * 0.5)
                let electronCount = electronsPerOrbit[orbitIndex]
                
                ZStack {
                    Circle()
                        .strokeBorder(.white, lineWidth: 1.5)
                        .frame(width: orbitRadius, height: orbitRadius)
                    
                    // MARK: - 전자 배치
                    ForEach(0..<electronCount, id: \.self) { electronIndex in
                        let angle = (360.0 / Double(electronCount)) * Double(electronIndex)
                        let radians = angle * .pi / 180.0
                        
                        let x = cos(radians) * (orbitRadius / 2)
                        let y = sin(radians) * (orbitRadius / 2)
                        
                        Electron()
                            .offset(x: x, y: y)
                    }
                }
            }
        }
    }
}
