//
//  UserExerciseResponse.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/7/25.
//

import Foundation

struct UserExerciseResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserExerciseResult
}

struct UserExerciseResult: Decodable {
    let userExercises: [UserExercise]?
    
    enum CodingKeys: String, CodingKey {
        case userExercises
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 배열로 직접 반환되는 경우
        if let exercises = try? container.decode([UserExercise].self, forKey: .userExercises) {
            self.userExercises = exercises
        } else {
            // 다른 형태로 반환되는 경우를 위한 fallback
            self.userExercises = []
        }
    }
}

struct ExerciseSet: Decodable {
    let setId: Int
    let setNumber: Int
    let count: Int
    let weight: Int
    let completed: Bool
}

struct UserExercise: Decodable {
    let userExerciseId: Int
    let recordType: String
    let currentSetNumber: Int
    let totalSets: Int
    let exerciseName: String
    let date: String
    let state: String
    let exerciseType: String
    let actualMinutes: Int
    let exerciseId: Int
    let exerciseSets: [ExerciseSet]
    let caloriesBurned: Double
}
