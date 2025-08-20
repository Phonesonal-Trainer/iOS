//
//  ExerciseRecommendationResponse.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 8/15/25.
//

import Foundation

// 운동 추천 API 응답 모델
struct ExerciseRecommendationResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}
