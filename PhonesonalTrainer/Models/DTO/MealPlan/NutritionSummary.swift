//
//  NutritionSummary.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import Foundation

// Meal 상태 (명세서: NONE / NO_IMAGE / WITH_IMAGE)
enum MealStatus: String, Codable {
    case none = "NONE"
    case noImage = "NO_IMAGE"
    case withImage = "WITH_IMAGE"
}

// 서버에서 내려주는 각 식사 카드 합계
struct MealCardSummary: Codable {
    let carb: Double
    let protein: Double
    let fat: Double
    let calorie: Double
    let recordCount: Int
    let imageUrl: String?
    let status: MealStatus
}

// 서버 전체 응답
struct NutritionSummaryResponse: Codable {
    let date: String
    let summary: Summary
    
    struct Summary: Codable {
        let breakfast: MealCardSummary
        let lunch: MealCardSummary
        let snack: MealCardSummary
        let dinner: MealCardSummary
    }
}
