//
//  FoodServiceType.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/14/25.
//

import Foundation
import UIKit

protocol FoodServiceType {
    func toggleFavorite(foodId: Int, token: String?) async throws -> Bool
    func searchFoods(keyword: String, sort: SortType?, token: String?) async throws -> [MealModel]
    func addUserMealFromFood(foodId: Int, date: Date, mealTime: MealType, token: String?) async throws -> UserMealItem
    func addCustomUserMeal(name: String, calorie: Double, carb: Double, protein: Double, fat: Double,
                               date: Date, mealTime: MealType, token: String?) async throws
    func fetchNutritionSummary(date: String, token: String?) async throws -> NutritionSummaryResponse
    func uploadMealImage(date: Date, mealTime: String, image: UIImage, token: String?) async throws -> MealImageResponse
}
