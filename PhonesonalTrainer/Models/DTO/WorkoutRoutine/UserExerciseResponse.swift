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
    let result: [UserExercise]
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
