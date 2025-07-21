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
    /// 사용자가 선택한 원소
    @State private var selectedElement: Element? = nil

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            
            // MARK: - 레이아웃 계산
            
            let totalWidth = geometry.size.width
            let leftWidth = totalWidth * 0.7           // 좌측 주기율표 영역
            let rightWidth = totalWidth - leftWidth    // 우측 상세보기 영역
            
            HStack(spacing: 0) {
                
                // MARK: - 주기율표 뷰 (왼쪽)
                PeriodicTableView(
                    selectedElement: $selectedElement,
                    elementsGrid: elementsGrid,
                    containerWidth: leftWidth,
                    containerHeight: geometry.size.height
                )
                .frame(minWidth: leftWidth)

                Divider() // 가운데 구분선
                
                // MARK: - 상세 정보 뷰 (오른쪽)
                if let element = selectedElement {
                    ElementDetailView(
                        element: element,
                        containerWidth: rightWidth,
                        containerHeight: geometry.size.height
                    )
                    .frame(minWidth: rightWidth)
                } else {
                    
                    // MARK: - 기본 안내 뷰 (선택 전)
                    VStack {
                        Spacer()
                        Text("원소를 선택해주세요.")
                        .font(
                        Font.custom("SF Pro Display", size: 26)
                        .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.2))

                        .frame(width: 288, alignment: .top)
                        Spacer()
                    }
                    .frame(minWidth: 400)
                }
            }
        }
    }
}
