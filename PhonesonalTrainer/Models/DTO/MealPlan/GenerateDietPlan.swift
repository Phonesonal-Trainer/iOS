//
//  GenerateDietPlan.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import Foundation

struct GenerateDietPlanRequest: Encodable {
    let startDate: String
}

struct GenerateDietPlanResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: Int
}
