//
//  MealPlanViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/18/25.
//

import Foundation

@Observable
class MealPlanViewModel {
    var selectedDate: Date = .now
    // 초기 설정
    var selectedType: MealType = .breakfast
}
