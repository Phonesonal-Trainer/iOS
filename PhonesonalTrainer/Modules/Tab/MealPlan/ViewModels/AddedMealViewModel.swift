//
//  AddedMealViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/29/25.
//

import Foundation

class AddedMealViewModel: ObservableObject {
    @Published var addedMeals: [MealModel] = []
    @Published var isLoading: Bool = false
    
    func fetchMeals(for mealType: MealType) {
        isLoading = true
            
        // 예시: 서버 통신 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addedMeals = [
                MealModel(name: "닭가슴살", amount: 200, kcal: 250, imageURL: "temp_image"),
                MealModel(name: "현미밥", amount: 150, kcal: 200, imageURL: "temp_image")
            ]
            self.isLoading = false
        }
    }
    
    func deleteMeal(_ meal: MealModel) {
        // 서버에 삭제 요청 보내는 로직 추가 필요
        addedMeals.removeAll { $0.id == meal.id }
    }
}
