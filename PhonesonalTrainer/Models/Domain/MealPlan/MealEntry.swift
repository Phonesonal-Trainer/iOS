//
//  MealEntry.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/1/25.
//

import Foundation

struct MealRecordEntry: Identifiable {
    let id = UUID()
    let meal: MealModel
    let nutrient: NutrientInfoModel
}
