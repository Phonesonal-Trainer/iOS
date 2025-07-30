//
//  NutrientInfoModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/22/25.
//

/// 재사용 가능함.
/// 식단 1, 식단 11 (전체적인 영양정보 -> mealType 필요)
/// 식단 검색 4 (각 식단의 영양정보 -> mealType 필요 없음)
import Foundation

/// Codable 프로토콜로 인해 인코딩 + 디코딩 둘 다 쉽게 됨.
struct NutrientInfoModel: Codable, Identifiable {
    let id = UUID()
    let mealType: String?   // 식단 정보 뷰에서 재사용하기 위해서 옵셔널로 둠.
    let kcal: Double
    let carb: Double
    let protein: Double
    let fat: Double
    
    /// 디코딩할 때마다 새로운 UUID 가 생성되지 않기 위해
    /// 직접 CodingKeys를 지정하여 id를 제외.
    private enum CodingKeys: String, CodingKey {
        case mealType, kcal, carb, protein, fat
    }
}
