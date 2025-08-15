//
//  CalorieProgressMealViewModel.swift
//  PhonesonalTrainer
//

import Foundation
import SwiftUI

@MainActor
final class CalorieProgressMealViewModel: ObservableObject {
    @Published var kcal: Int
    @Published var goal: Int

    // (0 ~ 999%)
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

    // 홈 API 값으로 갱신
    func apply(kcal: Int, goal: Int) {
        self.kcal = kcal
        self.goal = goal
    }
}
