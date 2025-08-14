//
//  MealEntry.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/1/25.
//

import Foundation

struct MealRecordEntry: Identifiable {
    let id = UUID()
    let recordId: Int   // 서버 recordId (삭제/수정 등에 사용)
    let meal: MealModel
    let nutrient: NutrientInfoModel
    let custom: Bool                 // ← 사용자 직접 입력 여부 (true면 수정 불가)
    var isEditable: Bool { !custom } // 검색 기반만 수정 가능
}

extension MealRecordEntry {
    init(api: UserMealItem) {
        self.recordId = api.recordId
        self.custom   = api.custom
        self.meal = MealModel(
            foodId: api.foodId,
            name: api.foodName,
            amount: api.quantity,               // g
            kcal: api.calorie,                  // 서버는 calorie
            imageURL: api.imageUrl ?? "",
            isComplete: true                    // ‘추가 식단’은 이미 섭취로 기록된 리스트이므로 true 가 자연스러움
        )
        self.nutrient = NutrientInfoModel(
            mealType: api.mealTime,
            kcal: api.calorie,
            carb: api.carb,
            protein: api.protein,
            fat: api.fat
        )
    }
}
