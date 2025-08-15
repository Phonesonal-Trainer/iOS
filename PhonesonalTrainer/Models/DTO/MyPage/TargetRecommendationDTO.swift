//
//  TargetRecommendationDTO.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/15/25.
//

struct TargetRecommendationDTO: Decodable {
    let weight: Double
    let targetWeight: Double
    let targetBMI: Double
    let targetMuscleMass: Double
    let bodyFatRate: Double
    let targetedBodyFatRate: Double
    let recommendedNutrition: String
    let recommendedCalories: Int
    let workoutFrequency: Int
    let cardioDaysPerWeek: Int
    let cardioMinutesPerWeek: Int
    let strengthTrainingDays: Int
    let strengthTrainingTime: Int
    let overallRecommendation: String
    let bmi: Double
}
