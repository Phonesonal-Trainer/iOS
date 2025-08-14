//
//  CreateCustomUserExercise.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/14/25.
//

import Foundation

// 요청 바디
struct CreateCustomUserExerciseRequest: Encodable {
    let exerciseName: String
    let kcal: Double  // 서버 required. 미입력 시 0으로 보냄
    let exerciseType: String  // "anaerobic" | "aerobic"
}

// 응답
struct CreateCustomUserExerciseResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserExercise
}
