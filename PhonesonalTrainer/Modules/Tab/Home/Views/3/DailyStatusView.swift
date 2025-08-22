//
//  DailyStatusView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//
import SwiftUI

struct DailyStatusView: View {
    // BodyWeightStore를 EnvironmentObject로 주입받아 직접 사용합니다.
    @EnvironmentObject var weightStore: BodyWeightStore

    let todayCalories: Int
    let targetCalories: Int
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
                    // weightStore에서 직접 currentWeight와 goalWeight 값을 가져옵니다.
                    currentWeight: weightStore.currentWeight,
                    goalWeight: weightStore.goalWeight,
                    onTap: onWeightTap
                )
                TotalCalorieView(
                    todayCalories: todayCalories,
                    targetCalories: targetCalories
                )
            }
        }
        .frame(width: 341.11, height: 169)
    }
}

#Preview {
    DailyStatusView(
        todayCalories: 1450,
        targetCalories: 1800,
        onWeightTap: {
            print("몸무게 팝업 띄우기")
        }
    )
    .environmentObject(BodyWeightStore())
}
