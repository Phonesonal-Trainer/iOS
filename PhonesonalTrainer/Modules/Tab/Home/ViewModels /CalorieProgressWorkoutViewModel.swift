//
//  CalorieProgressWorkoutViewModel.swift
//  PhonesonalTrainer
//

import Foundation
import SwiftUI

@MainActor
final class CalorieProgressWorkoutViewModel: ObservableObject {
    @Published var kcal: Int      // todayBurnedCalories
    @Published var goal: Int      // todayRecommendBurnedCalories

    var percentage: Double {
        guard goal > 0 else { return 0 }
        return min(Double(kcal) / Double(goal), 9.99)
    }

    var statusText: String {
        percentage >= 1.0 ? "달성" : "부족"
    }

    var badgeText: String {
        let diff = goal - kcal
        return "\(abs(diff).formattedWithSeparator)kcal \(diff > 0 ? "부족" : "초과")"
    }

    init(kcal: Int, goal: Int) {
        self.kcal = kcal
        self.goal = goal
    }

    // 홈 API 값으로 갱신
    func apply(kcal: Int, goal: Int) {
        self.kcal = kcal
        self.goal = goal
    }
}
