//
//  ExerciseRecommendationResponse.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 8/15/25.
//

import Foundation

// MARK: - 운동 추천 생성 API 응답
struct ExerciseRecommendationResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String  // 성공 결과만 뜨고, api 결과 내용은 디비에 직접 저장됨
}
