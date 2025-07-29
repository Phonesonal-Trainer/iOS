//
//  CalorieProgressWorkoutViewModel.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/28/25.
//
import Foundation
import SwiftUI

final class CalorieProgressWorkoutViewModel: ObservableObject {
    @Published var kcal: Int
    @Published var goal: Int

    // Double 타입으로 변경 (0.0 ~ 9.99)
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
}

