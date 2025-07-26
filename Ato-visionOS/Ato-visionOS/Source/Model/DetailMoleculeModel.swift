//
//  DetailMoleculeModel.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/23/25.
//

import Foundation

struct DetailMoleculeModel: Identifiable, Equatable, Hashable {
    let id: Int                 // 분자 아이디
    let symbol: String          // "H2O"
    let name: String            // "물" or "Oxidane"
    let description: String     // 상세 설명
    let composition: String     // "H, O"
}
