//
//  MealModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/15/25.
//

import Foundation

struct MealModel : Identifiable {
    let id : UUID = UUID()
    let name : String    // ex) "소고기"
    let amount : String     // ex) "180g"
    let kcal : String      // ex) "321kcal"
    let imageName : String?
}
