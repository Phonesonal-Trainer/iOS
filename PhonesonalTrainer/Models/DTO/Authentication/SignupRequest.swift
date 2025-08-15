//
//  SignupRequest.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/25/25.
//

import Foundation

struct SignupRequest: Codable {
    let tempToken: String
    let nickname: String
    let age: Int
    let gender: String
    let purpose: String
    let deadline: Int
    let height: Double
    let weight: Double
    let bodyFatRate: Double?
    let muscleMass: Double?
}
