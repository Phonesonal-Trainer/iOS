//
//  DayPlanModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/15/25.
//

import Foundation

enum MealType: String, CaseIterable {
    case breakfast = "아침"
    case lunch = "점심"
    case dinner = "저녁"
    case snack = "간식"
}

struct DayPlanModel: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let meals: [MealType: [MealModel]]
    let nutrition : [MealType: MealRecordModel]
    let totalKcal : Int
    let goalKcal : Int
}
