//
//  MealInfoViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/28/25.
//

import Foundation
import SwiftUI

class MealInfoViewModel: ObservableObject {
    @Published var meal: MealModel
    @Published var nutrient: NutrientInfoModel
    @Published var isFavorite: Bool
    @Published var originalAmount: Int

    init(meal: MealModel, nutrient: NutrientInfoModel, isFavorite: Bool = false) {
        self.meal = meal
        self.nutrient = nutrient
        self.isFavorite = isFavorite
        self.originalAmount = meal.amount
    }

    func toggleFavorite() {
        isFavorite.toggle()
        // 서버 or 로컬 저장 로직 연결 가능
    }

    func updateAmount(by delta: Int) {
        let newAmount = max(1, meal.amount + delta)
        let factor = Double(newAmount) / Double(originalAmount)
        
        meal = MealModel(
            id: meal.id,
            name: meal.name,
            amount: newAmount,
            kcal: Int(Double(meal.kcal) * factor),
            imageURL: meal.imageURL
        )
        
        nutrient = NutrientInfoModel(
            mealType: nutrient.mealType,
            kcal: Int(Double(nutrient.kcal) * factor),
            carb: Int(Double(nutrient.carb) * factor),
            protein: Int(Double(nutrient.protein) * factor),
            fat: Int(Double(nutrient.fat) * factor)
        )
    }

    var hasChanges: Bool {
        return meal.amount != originalAmount
    }
}
