//
//  UpdateUserMealQuantity.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/13/25.
//

import Foundation

struct UpdateUserMealQuantityRequest: Encodable {
    let quantity: Int
}

struct UpdateUserMealQuantityResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UpdateUserMealQuantityResult
}

struct UpdateUserMealQuantityResult: Decodable {
    let recordId: Int
    let quantity: Int
    let displayedServingSize: String?
}
