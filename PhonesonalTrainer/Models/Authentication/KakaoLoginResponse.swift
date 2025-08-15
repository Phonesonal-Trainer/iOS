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
    let tempToken: String?      // null 가능
    let user: LoginUser?        // null 가능 
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
    let currentGoalPeriodId: Int?
    let diagnosis: Diagnosis?
    let dailyExerciseRecord: DailyExerciseRecord?
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, nickname, socialType, gender
        case height, weight, bodyFatRate, muscleMass
        case bodyFatPercentage, skeletalMuscleWeight
        case age, deadline, purpose, currentGoalPeriodId
        case diagnosis, dailyExerciseRecord
        case createdAt = "created_at"  // 백엔드 created_at → 프론트엔드 createdAt
    }
}



// MARK: - diagnosis 객체
struct Diagnosis: Codable {
    let id: Int
    let targetWeight: Double
    let targetBMI: Double
    let targetMuscleMass: String?          // null 가능
    let targetBodyFatRate: Double?         // null 가능
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
