//
//  KakaoLoginResponse.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//


// MARK: - 전체 응답
struct KakaoLoginResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LoginResult
}

// MARK: - result 객체 내부
struct LoginResult: Codable {
    let accessToken: String
    let refreshToken: String
    let tempToken: String
    let user: LoginUser  // ✅ 이름 변경
    let newUser: Bool
}

// MARK: - user 객체
struct LoginUser: Codable {
    let id: Int
    let email: String
    let name: String
    let nickname: String
    let socialType: String
    let gender: String
    let height: Double?
    let weight: Double?
    let bodyFatRate: Double?
    let muscleMass: Double?
    let bodyFatPercentage: Double?
    let skeletalMuscleWeight: Double?
    let age: Int
    let deadline: Int
    let purpose: String
    let createdAt: String
    let currentGoalPeriodId: Int
    let diagnosis: Diagnosis?
    let dailyExerciseRecord: DailyExerciseRecord?
}



// MARK: - diagnosis 객체
struct Diagnosis: Codable {
    let id: Int
    let targetWeight: Double
    let targetBMI: Double
    let targetMuscleMass: String
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

// MARK: - dailyExerciseRecord 객체
struct DailyExerciseRecord: Codable {
    let id: Int
    let user: String
    let date: String
    let totalCalories: Int
    let anaerobicMinutes: Int
    let aerobicMinutes: Int
    let createdAt: String
    let updatedAt: String
}
