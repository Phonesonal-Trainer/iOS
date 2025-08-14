//
//  ToggleFavorite.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/13/25.
//

import Foundation



struct ToggleFavoriteResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ToggleFavoriteResult
}
struct ToggleFavoriteResult: Decodable {
    let foodId: Int
    let favorite: Bool
}


