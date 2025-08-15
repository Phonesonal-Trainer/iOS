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
struct NutrientInfoModel: Identifiable, Codable {
    var id: UUID = .init()
    let mealType: String?   // "아침", "점심", "간식", "저녁"
    let kcal: Double
    let carb: Double
    let protein: Double
    let fat: Double
    let imageUrl: String?
    let status: MealStatus
}

// 서버 응답의 각 식사 카드 -> 화면 모델 변환용
extension NutrientInfoModel {
    init(mealType: String, from s: MealCardSummary) {
        self.mealType = mealType
        self.kcal = s.calorie
        self.carb = s.carb
        self.protein = s.protein
        self.fat = s.fat
        self.imageUrl = s.imageUrl
        self.status = s.status
    }
}
