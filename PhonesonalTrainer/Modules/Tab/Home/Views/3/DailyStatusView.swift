//
//  DailyStatusView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//
import SwiftUI

struct DailyStatusView: View {
    let currentWeight: Double
    let goalWeight: Double
    let totalCalorie: Int
    let calorieGoal: Int
    let onWeightTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 상단 타이틀
            Text("오늘 내 상태")
                .font(.system(size: 20))
                .foregroundStyle(.grey05)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 나란히 배치
            HStack(spacing: 20) {
                WeightInfoView(
                    currentWeight: currentWeight,
                    goalWeight: goalWeight,
                    onTap: onWeightTap
                )
                TotalCalorieView(
                    totalCalorie: totalCalorie,
                    calorieGoal: calorieGoal
                )
            }
        }
        .frame(width: 341.11, height: 169)
    }
}
#Preview {
    DailyStatusView(
        currentWeight: 65.3,
        goalWeight: 60.0,
        totalCalorie: 1450,
        calorieGoal: 1800,
        onWeightTap: {
            print("몸무게 팝업 띄우기")  // 실제 앱에서는 팝업 띄우는 로직 연결
        }
    )
}
