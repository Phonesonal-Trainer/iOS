//
//  CalorieProgressMealViewModel.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/28/25.
//
import Foundation
import SwiftUI

final class CalorieProgressMealViewModel: ObservableObject {
    @Published var kcal: Int
    @Published var goal: Int

    // 섭취 비율 계산 (0 ~ 999%)
    var percentage: Int {
        guard goal > 0 else { return 0 }
        return min((kcal * 100) / goal, 999)
    }

    var badgeText: String {
        let diff = goal - kcal
        return "\(abs(diff).formattedWithSeparator)kcal \(diff > 0 ? "부족" : "초과")"
    }

    init(kcal: Int, goal: Int) {
        self.kcal = kcal
        self.goal = goal
    }
}
