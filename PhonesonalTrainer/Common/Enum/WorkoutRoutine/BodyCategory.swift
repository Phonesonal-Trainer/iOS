//
//  BodyCategory.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/12/25.
//

import Foundation

enum BodyCategory: String, CaseIterable {
    case chest
    case back
    case legs
    case arms
    case shoulders
    case unknown

    // JSON이 예상 밖 값이어도 앱이 죽지 않도록 안전 디코딩
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = BodyCategory(rawValue: raw) ?? .unknown
    }
}

extension BodyCategory: Decodable {}

extension BodyCategory {
    var displayName: String {
        switch self {
        case .chest: return "가슴"
        case .back: return "등"
        case .legs: return "다리"
        case .arms: return "팔"
        case .shoulders: return "어깨"
        case .unknown: return "기타"
        }
    }
}
