//
//  UserMealsResponse.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/12/25.
//

// 추가 기록 에 사용되는 api DTO
import Foundation

struct UserMealsResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [UserMealItem]
}

struct UserMealItem: Decodable {
    let recordId: Int
    let foodId: Int
    let foodName: String
    let mealTime: String
    let date: String
    let carb: Double
    let protein: Double
    let fat: Double
    let calorie: Double
    let quantity: Int
    let displayServingSize: String?
    let defaultServingSize: String?
    let imageUrl: String?
    let custom: Bool
}
