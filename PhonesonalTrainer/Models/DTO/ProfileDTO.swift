//
//  ProfileDTO.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/15/25.
//
import Foundation

struct ProfileDTO: Decodable {
    let nickname: String
    let age: Int
    let gender: GenderDTO
    let height: Int
}

enum GenderDTO: String, Decodable {
    case MALE, FEMALE
}

