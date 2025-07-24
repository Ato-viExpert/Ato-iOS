//
//  ElementDetailView.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import SwiftUI

// MARK: - ElementDetailView

/// 선택된 원소의 이름, 이미지, 설명을 보여주는 상세 정보 뷰
/// SplitPeriodicView의 오른쪽에 표시됨

struct ElementDetailView: View {
    
    // MARK: - Properties
    let element: Element
    
    private let containerWidth: CGFloat
    private let containerHeight: CGFloat
    
    // MARK: - Init
    
    /// - Parameters:
    ///   - element: 상세 정보를 표시할 원소
    ///   - containerWidth: 뷰 너비
    ///   - containerHeight: 뷰 높이
    init(element: Element, containerWidth: CGFloat, containerHeight: CGFloat){
        self.element = element
        self.containerWidth = containerWidth
        self.containerHeight = containerHeight
    }
    
    // MARK: - Body
    var body: some View {
        
        // MARK: - 레이아웃 관련 계산값
        let titleFontSize = max(min(containerWidth * 0.08, 48), 24)
        let bodyFontSize = max(min(containerWidth * 0.045, 20), 14)
        let verticalSpacing = containerWidth * 0.04
        let sidePadding = containerWidth * 0.05
        
        VStack(alignment: .center, spacing: verticalSpacing) {
            
            // MARK: - 원소 이름
            Text(element.name)
                .font(
                Font.custom("SF Pro Display", size: titleFontSize)
                .weight(.bold)
                )
                .multilineTextAlignment(.leading)
                .foregroundStyle(.white)
            
            Divider()
            
            // MARK: - 원소 이미지 + 설명 텍스트
            Image("H") //element.imageName
                .resizable()
                .frame(width: containerWidth * 0.4 ,height: 250, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .clipShape(.circle)
                .padding(20)
            
            Text(element.description)
                .font(Font.custom("SF Pro Display", size: bodyFontSize))
                .foregroundStyle(.white)
                .frame(width: 295.38199, alignment: .topLeading)

        }
        .padding(.horizontal, sidePadding)
        .padding(.vertical, 47)
    }
}

