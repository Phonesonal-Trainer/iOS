//
//  DiagnosisModel.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import Foundation

struct DiagnosisModel: Codable {
    let id: Int
    let targetWeight: Int
    let targetBMI: Int
    let targetMuscleMass: String
    let targetBodyFatRate: Int
    let recommendedNutrition: String
    let recommendedCalories: Int
    let workoutFrequency: Int
    let cardioDaysPerWeek: Int
    let cardioMinutesPerWeek: Int
    let strengthTrainingDays: Int
    let strengthTrainingTime: Int
    let overallRecommendation: String
}
