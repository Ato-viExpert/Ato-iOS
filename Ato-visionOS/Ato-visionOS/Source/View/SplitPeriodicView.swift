//
//  SplitPeriodicView.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import SwiftUI

// MARK: - SplitPeriodicView

/// 주기율표(왼쪽)와 원소 상세정보(오른쪽)를 좌우로 나눈 메인 뷰
/// 사용자가 원소를 선택하면 오른쪽에 상세정보가 표시됨

struct SplitPeriodicView: View {
    
    // MARK: - State
    // 사용자가 선택한 원소
    @State private var selectedAtom: DetailAtomModel? = nil

    // MARK: - Body
    var body: some View {
        GeometryReader {geometry in
            let size = geometry.size
            let width: CGFloat = geometry.size.width
            let height: CGFloat = geometry.size.height
//            let dynamicCorner = min(30, min(width, height) * 0.05)
            
            HStack(spacing: 10) {
                // MARK: - 주기율표 뷰 (왼쪽)
                
                PeriodicTableView(
                    selectedAtom: $selectedAtom,
                    elementsGrid: elementsGrid,
                    width: width * 0.71,
                    height: height
                )
                .frame(width: width * 0.71, height: height)
                .background(
                  LinearGradient(
                    stops: [
                      Gradient.Stop(color: .white.opacity(0.37), location: 0.00),
                      Gradient.Stop(color: Color(red: 0.45, green: 0.45, blue: 0.45).opacity(0.42), location: 0.95),
                    ],
                    startPoint: UnitPoint(x: 0, y: -0.06),
                    endPoint: UnitPoint(x: 1, y: 1)
                  )
                )
                .cornerRadius(55)
                
                
                Color.clear
                    .frame(width: width * 0.001)
        
                // MARK: - 상세 정보 뷰 (오른쪽)
                Group {
                    if let element = selectedAtom {
                        ElementDetailView(element: element, width: width * 0.28, height: height)
                    } else {
                        VStack {
                            Spacer()
                            Text("원소를 선택해주세요.")
                                .font(
                                    Font.custom("SF Pro Display", size: width * 0.02)
                                .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.2))
                                //.dynamicTypeSize(.xLarge)
                            Spacer()
                        }
                    }
                }
                .frame(width: width * 0.28, height: height)
                .background(
                  LinearGradient(
                    stops: [
                      Gradient.Stop(color: .white.opacity(0.37), location: 0.00),
                      Gradient.Stop(color: Color(red: 0.45, green: 0.45, blue: 0.45).opacity(0.42), location: 0.95),
                    ],
                    startPoint: UnitPoint(x: 0, y: -0.06),
                    endPoint: UnitPoint(x: 1, y: 1)
                  )
                )
                .cornerRadius(55)
            }
            .background(
                Color.clear
                    .preference(key: SplitViewWindowSizeKey.self, value: size)
                )
        }
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat = 30.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct SplitViewWindowSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
