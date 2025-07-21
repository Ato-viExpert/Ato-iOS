//
//  AtomType.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import SwiftUI

enum AtomType: String, CaseIterable {
    case H, He
    case Li, Be, B, C, N, O, F, Ne
    case Na, Mg, Al, Si, P, S, Cl, Ar
    case K, Ca
    case Br, I
    
    /// 원자 부호
    var symbol: String { String(describing: self) }
    
    /// 원자 이름 -> 수소, Hydrogen 다국어 지원
    var localizedName: LocalizedStringKey {
        return LocalizedStringKey("atom.name.\(self.rawValue)")
    }
    
    /// 원자 번호
    var atomicNumber: Int {
        switch self {
        case .H: return 1
        case .He: return 2
        case .Li: return 3
        case .Be: return 4
        case .B: return 5
        case .C: return 6
        case .N: return 7
        case .O: return 8
        case .F: return 9
        case .Ne: return 10
        case .Na: return 11
        case .Mg: return 12
        case .Al: return 13
        case .Si: return 14
        case .P: return 15
        case .S: return 16
        case .Cl: return 17
        case .Ar: return 18
        case .K: return 19
        case .Ca: return 20
        case .Br: return 35
        case .I: return 53
        }
    }
    
    /// 최외각 전자수
    var valenceElectrons: Int {
        switch self {
        case .H: return 1
        case .He: return 2
        case .Li: return 1
        case .Be: return 2
        case .B: return 3
        case .C: return 4
        case .N: return 5
        case .O: return 6
        case .F: return 7
        case .Ne: return 8
        case .Na: return 1
        case .Mg: return 2
        case .Al: return 3
        case .Si: return 4
        case .P: return 5
        case .S: return 6
        case .Cl: return 7
        case .Ar: return 8
        case .K: return 1
        case .Ca: return 2
        case .Br: return 7
        case .I: return 7
        }
    }
    
    /// 주기율표 족
    var group: Int {
        switch self {
        case .H: return 1
        case .He: return 18
        case .Li: return 1
        case .Be: return 2
        case .B: return 13
        case .C: return 14
        case .N: return 15
        case .O: return 16
        case .F: return 17
        case .Ne: return 18
        case .Na: return 1
        case .Mg: return 2
        case .Al: return 13
        case .Si: return 14
        case .P: return 15
        case .S: return 16
        case .Cl: return 17
        case .Ar: return 18
        case .K: return 1
        case .Ca: return 2
        case .Br: return 17
        case .I: return 17
        }
    }
    
    /// 중성자수
    var neutronCount: Int {
        switch self {
        case .H: return 1
        case .He: return 2
        case .Li: return 4
        case .Be: return 5
        case .B: return 6
        case .C: return 6
        case .N: return 7
        case .O: return 8
        case .F: return 10
        case .Ne: return 10
        case .Na: return 12
        case .Mg: return 12
        case .Al: return 14
        case .Si: return 14
        case .P: return 16
        case .S: return 16
        case .Cl: return 18
        case .Ar: return 22
        case .K: return 20
        case .Ca: return 20
        case .Br: return 45
        case .I: return 74
        }
    }
    
    /// 원자 크기
    var modelScale: Float {
        switch self {
        case .H: return 0.04
        case .He: return 0.045
        case .Li: return 0.06
        case .Be: return 0.058
        case .B: return 0.055
        case .C: return 0.052
        case .N: return 0.051
        case .O: return 0.05
        case .F: return 0.05
        case .Ne: return 0.048
        case .Na: return 0.065
        case .Mg: return 0.062
        case .Al: return 0.061
        case .Si: return 0.06
        case .P: return 0.059
        case .S: return 0.058
        case .Cl: return 0.057
        case .Ar: return 0.055
        case .K: return 0.07
        case .Ca: return 0.068
        case .Br: return 0.072
        case .I: return 0.078
        }
    }
    
    /// diffuse Color
    var diffuseColor: UIColor {
        switch self {
        case .H: return UIColor(hex: "#6DC0FF")
        case .He: return UIColor(hex: "#B6F8FF")
        case .Li: return UIColor(hex: "#57FFBE")
        case .Be: return UIColor(hex: "#C17CFF")
        case .B: return UIColor(hex: "#FF77C2")
        case .C: return UIColor(hex: "#000000")
        case .N: return UIColor(hex: "#0535FF")
        case .O: return UIColor(hex: "#FF4884")
        case .F: return UIColor(hex: "#FF7800")
        case .Ne: return UIColor(hex: "#FFADF7")
        case .Na: return UIColor(hex: "#004820")
        case .Mg: return UIColor(hex: "#E2D8FF")
        case .Al: return UIColor(hex: "#FF02A9")
        case .Si: return UIColor(hex: "#000000")
        case .P: return UIColor(hex: "#061CFF")
        case .S: return UIColor(hex: "#FFF000")
        case .Cl: return UIColor(hex: "#4C9D00")
        case .Ar: return UIColor(hex: "#FFE7AB")
        case .K: return UIColor(hex: "#00FF6A")
        case .Ca: return UIColor(hex: "#FF4884")
            // TODO: - Br 색상 물어봐야함
        case .Br: return UIColor(hex: "#8D22FF")
        case .I: return UIColor(hex: "#C5FF17")
        }
    }
    
    /// emissive Color
    var emissiveColor: UIColor {
        switch self {
        case .H: return UIColor(hex: "#0072FF")
        case .He: return UIColor(hex: "#31E3FF")
        case .Li: return UIColor(hex: "#00FF9A")
        case .Be: return UIColor(hex: "#8D00FF")
        case .B: return UIColor(hex: "#FFA1EC")
        case .C: return UIColor(hex: "#000000")
        case .N: return UIColor(hex: "#7CB3FF")
        case .O: return UIColor(hex: "#FF0000")
        case .F: return UIColor(hex: "#FF8F50")
        case .Ne: return UIColor(hex: "#FFD5D0")
        case .Na: return UIColor(hex: "#008409")
        case .Mg: return UIColor(hex: "#8E00FF")
        case .Al: return UIColor(hex: "#FF008E")
        case .Si: return UIColor(hex: "#6E6F6F")
        case .P: return UIColor(hex: "#9341FF")
        case .S: return UIColor(hex: "#FF951E")
        case .Cl: return UIColor(hex: "#2DFF00")
        case .Ar: return UIColor(hex: "#FFD5A8")
        case .K: return UIColor(hex: "#009400")
        case .Ca: return UIColor(hex: "#8D22FF")
            // TODO: - Br 색상 물어봐야함
        case .Br: return UIColor(hex: "#8D22FF")
        case .I: return UIColor(hex: "#00C865")
        }
    }
}
