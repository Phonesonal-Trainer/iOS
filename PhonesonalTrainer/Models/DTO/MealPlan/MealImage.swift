//
//  UploadMealImage.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/17/25.
//

import Foundation

// 응답 모델
struct MealImageResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MealImageResult
}

struct MealImageResult: Codable {
    let id: Int
    let date: String
    let mealTime: String
    let imageUrl: String
}
