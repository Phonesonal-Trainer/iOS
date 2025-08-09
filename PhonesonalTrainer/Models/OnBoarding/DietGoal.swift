//
//  DietGoal.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//


import Foundation

struct DietGoal: Identifiable, Codable {
    let id = UUID()
    let key: String
    let value: String
}
