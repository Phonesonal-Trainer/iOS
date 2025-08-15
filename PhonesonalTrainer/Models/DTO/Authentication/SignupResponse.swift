//
//  SignupResponse.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/25/25.
//

import Foundation

struct SignupResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SignupResult?
}

struct SignupResult: Codable {
    let accessToken: String
    let refreshToken: String
    let tempToken: String
    let user: SignupUserProfile
    let newUser: Bool
}

struct SignupUserProfile: Codable {
    let id: Int
    let email: String?
    let name: String?
    let nickname: String
    let socialType: String
    let gender: String
    let height: Double
    let weight: Double
    let bodyFatRate: Double?
    let muscleMass: Double?
    let age: Int
    let deadline: Int
    let profileImageUrl: String?
    let purpose: String
    let created_at: String
    let currentGoalPeriodId: Int?     // 백엔드 스펙에 맞춤
    let diagnosis: SignupDiagnosis?
    let dailyExerciseRecord: SignupDailyExerciseRecord?
}

struct SignupGoalPeriod: Codable {
    let createdAt: String
    let updatedAt: String
    let id: Int
    let startDate: String
    let endDate: String
    let userExercises: [SignupUserExercise]
}

struct SignupUserExercise: Codable {
    let id: Int
    let currentSetNumber: Int
    let state: String
    let exerciseDate: String
    let setCount: Int
    let bookmark: Bool
    let exercise: SignupExercise
    let user: String
    let customExerciseName: String?
    let caloriesBurned: Double
    let customExerciseType: String
    let goalPeriod: String
    let actualMinutes: Int
    let customExercise: Bool
}

struct SignupExercise: Codable {
    let id: Int
    let name: String
    let defaultCount: Int
    let defaultWeight: Double
    let type: String
    let youtubeUrl: String?
    let kcal: Double
    let defaultSet: Int
    let caution: String?
    let imageUrl: String?
    let bodyParts: [SignupBodyPartExercise]
    let secondsPerRep: Int
    let descriptions: [SignupExerciseDescription]
}

struct SignupBodyPartExercise: Codable {
    let id: Int
    let exercise: String
    let bodyPart: SignupBodyPart
}

struct SignupBodyPart: Codable {
    let id: Int
    let nameEn: String
    let nameKo: String
    let bodyCategory: String
}

struct SignupExerciseDescription: Codable {
    let id: Int
    let exercise: String
    let step: Int
    let main: String
    let sub: String
}

struct SignupDiagnosis: Codable {
    let id: Int
    let targetWeight: Double
    let targetBMI: Double
    let targetMuscleMass: String     // 백엔드 스펙에 맞춤
    let targetBodyFatRate: Double
    let recommendedNutrition: String
    let recommendedCalories: Int
    let workoutFrequency: Int
    let cardioDaysPerWeek: Int
    let cardioMinutesPerWeek: Int
    let strengthTrainingDays: Int
    let strengthTrainingTime: Int
    let overallRecommendation: String
}

struct SignupDailyExerciseRecord: Codable {
    let id: Int
    let user: String
    let date: String
    let totalCalories: Double
    let anaerobicMinutes: Int
    let aerobicMinutes: Int
    let createdAt: String
    let updatedAt: String
}
