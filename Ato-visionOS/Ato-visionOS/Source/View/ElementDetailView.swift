//
//  ElementDetailView.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import SwiftUI

// MARK: - ElementDetailView
struct ElementDetailView: View {
    
    // MARK: - Properties
    let element: DetailAtomModel
    let width: CGFloat
    let height: CGFloat
    
    
    // MARK: - Init
    /// - Parameters:
    ///   - element: 상세 정보를 표시할 원소
    init(
        element: DetailAtomModel,
        width: CGFloat,
        height: CGFloat
    ){
        self.element = element
        self.width = width
        self.height = height
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // MARK: - 원소 이름
            VStack(alignment: .leading, spacing: 30) {
                Text("\(element.symbol)(\(element.name))")
                    .font(Font.custom("SF Pro Display", size: width * 0.08)
                        .weight(.bold)
                    )
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
                Divider()
                    .frame(width: width * 0.66)
                
            }
            .frame(height: height * 0.1)
            
                        
            // MARK: - 원소 이미지 + 설명 텍스트
//            Image("H") //element.imageName
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: width * 0.69)
//                .clipShape(.circle)
//                .padding(.bottom, 20) // 임시
            Spacer()
            Text(element.description)
                .font(Font.custom("SF Pro Display", size: width * 0.04))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(minHeight: height * 0.3)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, height * 0.05)
        .padding(.horizontal, width * 0.12)
    }
}

