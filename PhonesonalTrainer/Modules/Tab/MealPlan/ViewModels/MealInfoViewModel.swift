//
//  MealInfoViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/28/25.
//

import Foundation
import SwiftUI

final class MealInfoViewModel: ObservableObject {
    @Published var meal: MealModel
    @Published var nutrient: NutrientInfoModel
    @Published var isFavorite: Bool
    @Published var originalAmount: Int
    @Published var isTogglingFavorite = false
    
    let recordId: Int                 // ← PATCH에 필요
    let isEditable: Bool              // ← custom == false일 때 true
    
    private let originalMeal: MealModel
    private let originalNutrient: NutrientInfoModel

    init(entry: MealRecordEntry, isFavorite: Bool = false) {
        self.meal = entry.meal
        self.nutrient = entry.nutrient
        self.isFavorite = isFavorite
        self.originalAmount = entry.meal.amount
        self.recordId = entry.recordId
        self.isEditable = entry.isEditable

        self.originalMeal = entry.meal
        self.originalNutrient = entry.nutrient
    }

    @MainActor
    func toggleFavorite(using service: FoodServiceType, favorites: FavoritesStore) async {
        guard !isTogglingFavorite else { return }
        isTogglingFavorite = true
        let before = isFavorite
        isFavorite.toggle() // 낙관적
        do {
            let newState = try await service.toggleFavorite(foodId: meal.foodId, token: "")  // ***토큰 넣기
            isFavorite = newState
            favorites.apply(foodId: meal.foodId, isFavorite: newState)
        } catch {
            isFavorite = before // 롤백
        }
        isTogglingFavorite = false
    }

    func updateAmount(by delta: Double) {
        let newAmount = max(1, Int(round(Double(meal.amount) + delta)))
        let factor = Double(newAmount) / Double(originalAmount)
        
        // original 기준으로 항상 다시 계산
        meal = MealModel(
            id: originalMeal.id,
            foodId: originalMeal.foodId,
            name: originalMeal.name,
            amount: newAmount,
            kcal: (originalMeal.kcal ?? 0) * factor,
            imageURL: originalMeal.imageURL
        )
        
        // ✅ NutrientInfoModel의 id / imageUrl / status는 유지하고,
        //    kcal/carb/protein/fat만 스케일링
        nutrient = NutrientInfoModel(
            id: originalNutrient.id,                 // ← id 유지 (SwiftUI diff용)
            mealType: originalNutrient.mealType,
            kcal: originalNutrient.kcal * factor,
            carb: originalNutrient.carb * factor,
            protein: originalNutrient.protein * factor,
            fat: originalNutrient.fat * factor,
            imageUrl: originalNutrient.imageUrl,     // ← 이미지 유지
            status: originalNutrient.status          // ← 상태 유지
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
