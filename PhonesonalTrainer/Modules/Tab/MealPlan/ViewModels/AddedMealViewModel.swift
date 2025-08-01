//
//  AddedMealViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/29/25.
//

import Foundation

class AddedMealViewModel: ObservableObject {
    @Published var addedMeals: [MealRecordEntry] = []
    
    // 더미데이터로 일단 구현. api 받으면 연동
    init() {
        loadDummyData()
    }

    func loadDummyData() {
        addedMeals = [
            MealRecordEntry(
                meal: MealModel(name: "소고기", amount: 180, kcal: 321, imageURL: ""),
                    nutrient: NutrientInfoModel(mealType: "소고기", kcal: 321, carb: 0, protein: 26, fat: 24)
            ),
            MealRecordEntry(
                meal: MealModel(name: "닭가슴살", amount: 150, kcal: 230, imageURL: ""),
                    nutrient: NutrientInfoModel(mealType: "닭가슴살", kcal: 230, carb: 0, protein: 38, fat: 5)
            ),
            MealRecordEntry(
                meal: MealModel(name: "고구마", amount: 100, kcal: 120, imageURL: ""),
                    nutrient: NutrientInfoModel(mealType: "고구마", kcal: 120, carb: 30, protein: 2, fat: 0.1)
            )
        ]
    }

    func deleteMeal(_ entry: MealRecordEntry) {
        if let index = addedMeals.firstIndex(where: { $0.id == entry.id }) {
            addedMeals.remove(at: index)
        }
    }
}
