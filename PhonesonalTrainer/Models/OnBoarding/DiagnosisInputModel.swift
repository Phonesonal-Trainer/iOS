//
//  DiagnosisInputModel.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//

import Foundation

struct DiagnosisInputModel: Codable {
    let weightChange: MetricChange
    let bmiChange: MetricChange
    let bodyFatChange: MetricChange?
    let muscleMassChange: MetricChange?

    let comment: String
    let exerciseGoals: [ExerciseGoal]
    let dietGoals: [DietGoal]
}
