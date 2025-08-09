//
//  UserModel.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//


import Foundation

struct User: Codable {
    var height: Double
    var weight: Double
    var bodyFatRate: Double?
    var muscleMass: Double?

    static var empty: User {
        return User(
            height: 0.0,
            weight: 0.0,
            bodyFatRate: nil,
            muscleMass: nil
        )
    }
}
