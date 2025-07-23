//
//  DayPlanModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/15/25.
//

import Foundation


struct DayPlanModel: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let meals: [MealType: [MealModel]]
    // let nutrition : [MealType: MealRecordModel]
    let totalKcal : Int
    let goalKcal : Int
}
