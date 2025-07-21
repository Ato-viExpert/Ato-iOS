//
//  Element.swift
//  PeriodicSplitTable
//
//  Created by ellllly on 7/19/25.
//

import Foundation

// MARK: - Element

/// 주기율표에 표시될 원소를 나타내는 데이터 모델
/// 각 원소는 이름, 설명, 이미지 파일명을 포함하며,
/// 뷰에서 유일 식별이 가능하도록 UUID 기반의 `id`를 가짐

struct Element: Identifiable, Equatable {
    
    // MARK: - Properties
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
}

