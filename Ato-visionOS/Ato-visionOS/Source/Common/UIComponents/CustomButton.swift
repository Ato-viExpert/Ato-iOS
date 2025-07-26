//
//  CustomButton.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import SwiftUI

// MARK: - CustomButton

/// 원소의 심볼(예: "H", "He")을 표시하는 재사용 가능한 버튼 컴포넌트
/// 크기와 동작을 외부에서 주입할 수 있어 다양한 UI 레이아웃에 유연하게 사용 가능

//struct CustomButton: View {
//    
//    // MARK: - Properties
//    private let col: String
//    private let size: CGFloat
//    private let action: () -> Void
//    
//    // MARK: - Init
//    
//    /// - Parameters:
//    ///   - col: 버튼에 표시할 텍스트(원소)
//    ///   - size: 버튼의 정사각형 크기
//    ///   - action: 버튼 클릭 시 실행할 클로저
//    init(col: String, size: CGFloat, action: @escaping () -> Void){
//        self.col = col
//        self.size = size
//        self.action = action
//    }
//    
//    // MARK: - Body
//    var body: some View {
//        Button(action: action) {
//            Text(col)
//                .font(.system(size: size * 0.45, weight: .semibold))
//                .frame(width: size, height: size)
//                .background(
//                    RoundedRectangle(cornerRadius: size * 0.2)
//                        .fill(.white.opacity(0.3))
//                )
//        }
//        .buttonStyle(.plain)
//    }
//}



