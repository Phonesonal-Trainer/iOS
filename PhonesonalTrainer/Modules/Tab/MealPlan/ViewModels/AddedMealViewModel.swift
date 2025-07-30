//
//  AddedMealViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/29/25.
//

import Foundation

class AddedMealViewModel: ObservableObject {
    @Published var addedMeals: [MealModel] = []
    
    // 더미데이터로 일단 구현. api 받으면 연동
    init() {
        loadDummyData()
    }

    func loadDummyData() {
        addedMeals = [
            MealModel(name: "소고기", amount: 180, kcal: 321, imageURL: ""),
            MealModel(name: "닭가슴살", amount: 150, kcal: 230, imageURL: ""),
            MealModel(name: "고구마", amount: 100, kcal: 120, imageURL: "")
        ]
    }

    func deleteMeal(_ meal: MealModel) {
        if let index = addedMeals.firstIndex(where: { $0.id == meal.id }) {
            addedMeals.remove(at: index)
        }
    }
}
