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
        // 이미지 유무에 따라 카드 상태 추정 (개별 기록이므로 NONE은 아님)
        let status: MealStatus = {
            if let url = api.imageUrl, !url.isEmpty { return .withImage }
            else { return .noImage }
        }()

        // ✅ NutrientInfoModel은 id를 갖는다. 여기서 생성한 id는 이후 update에서도 유지할 것.
        self.nutrient = NutrientInfoModel(
            mealType: api.mealTime,     // 필요 시 한국어 레이블로 변환해도 됨
            kcal: api.calorie,
            carb: api.carb,
            protein: api.protein,
            fat: api.fat,
            imageUrl: api.imageUrl,
            status: status
        )

        // 만약 original* 값을 내부에서 별도로 보관한다면 여기서 스냅샷을 저장해 두세요.
        //self.originalMeal = self.meal
        //self.originalNutrient = self.nutrient
        //self.originalAmount = self.meal.amount
    }
}
