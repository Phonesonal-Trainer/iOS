//
//  MealListViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/21/25.
//

///  api 받아서 정보 처리.
///  지금은 임시로 더미데이터 사용.

import Foundation

class MealListViewModel: ObservableObject {
    @Published var mealItems: [MealModel] = [
        MealModel(name: "소고기", amount: "180g", kcal: "321 kcal", imageURL: "temp_image"),
        MealModel(name: "소고기", amount: "180g", kcal: "321 kcal", imageURL: "temp_image"),
        MealModel(name: "소고기", amount: "180g", kcal: "321 kcal", imageURL: "temp_image")
    ]
}
