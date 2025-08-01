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
    
    private let originalMeal: MealModel
    private let originalNutrient: NutrientInfoModel

    init(meal: MealModel, nutrient: NutrientInfoModel, isFavorite: Bool = false) {
        self.meal = meal
        self.nutrient = nutrient
        self.isFavorite = isFavorite
        self.originalAmount = meal.amount
        
        self.originalMeal = meal //  복사본 저장
        self.originalNutrient = nutrient
    }

    func toggleFavorite() {
        isFavorite.toggle()
        // 서버 or 로컬 저장 로직 연결 가능
    }

    func updateAmount(by delta: Double) {
        let newAmount = max(1, Int(round(Double(meal.amount) + delta)))
        let factor = Double(newAmount) / Double(originalAmount)
        
        // original 기준으로 항상 다시 계산
        meal = MealModel(
            id: originalMeal.id,
            name: originalMeal.name,
            amount: newAmount,
            kcal: originalMeal.kcal * factor,
            imageURL: originalMeal.imageURL
        )
        
        nutrient = NutrientInfoModel(
            mealType: originalNutrient.mealType,
            kcal: originalNutrient.kcal * factor,
            carb: originalNutrient.carb * factor,
            protein: originalNutrient.protein * factor,
            fat: originalNutrient.fat * factor
        )
    }
    
    func resetChanges() {
        self.meal = originalMeal
        self.nutrient = originalNutrient
    }

    var hasChanges: Bool {
        return meal.amount != originalAmount
    }
}
