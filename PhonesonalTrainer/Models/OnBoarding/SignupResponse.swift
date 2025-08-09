//
//  SignupResponse.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//


import Foundation

struct SignupResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SignupResult
}

struct SignupResult: Codable {
    let accessToken: String
    let refreshToken: String
    let tempToken: String
    let user: User
    let newUser: Bool
}
