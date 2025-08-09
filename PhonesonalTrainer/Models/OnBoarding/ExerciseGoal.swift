//
//  ExerciseGoal.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//


import Foundation

struct ExerciseGoal: Identifiable, Codable {
    let id = UUID()
    let type: String
    let mainInfo: String
    let detail: String?
}
