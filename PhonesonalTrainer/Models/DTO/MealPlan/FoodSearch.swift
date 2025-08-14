//
//  FoodSearch.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/14/25.
//

import Foundation

// MARK: - GET /foods/search
struct FoodSearchResponse: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: [FoodSearchItem]
}

struct FoodSearchItem: Decodable {
    let foodId: Int
    let name: String
    let servingSize: String
    let calorie: Double?
    let carb: Double?
    let protein: Double?
    let fat: Double?
    let imageUrl: String?
    let favorite: Bool?
}

// MARK: - POST /foods/user-meals/from-food
struct AddUserMealFromFoodRequest: Encodable {
    let foodId: Int
    let date: String      // "YYYY-MM-DD"
    let mealTime: String  // "BREAKFAST" ...
}

struct AddUserMealFromFoodResponse: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: UserMealItem   
}

// MARK: - POST /foods/user-meals/custom
struct AddCustomUserMealRequest: Encodable {
    let name: String
    let calorie: Double
    let carb: Double
    let protein: Double
    let fat: Double
    let date: String        // "YYYY-MM-DD"
    let mealTime: String    // MealType.rawValue
}

struct AddCustomUserMealResponse: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: String?     
}
