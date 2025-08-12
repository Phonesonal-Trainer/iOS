//
//  FoodPlanResponse.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/12/25.
//

import Foundation

struct FoodPlansResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [FoodPlanItem]
}

struct FoodPlanItem: Decodable, Identifiable {
    var id: Int { foodId }
    let foodId: Int
    let foodName: String
    let mealTime: String
    let date: String
    let quantity: Int
    let complete: String?
    let weekNumber: Int?
    let imageUrl: String?
}
