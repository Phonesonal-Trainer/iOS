//
//  CalorieGuageWorkoutView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/28/25.
//

import SwiftUI

struct CalorieGaugeWorkoutView: View {
    var percentage: Double
    

    var body: some View {
        let clamped = min(percentage, 1.0) // 100% 넘으면 고정

        ZStack {
            // 회색 백 원
            Circle()
                .stroke(.grey01, lineWidth: 6)
                .frame(width: 125, height: 125)

            // 텍스트
            VStack(spacing: 4) {
                Text("\(Int(percentage * 100))%")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.grey06)

                Text(percentage < 1.0 ? "부족" : "달성")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.orange05)
            }

            // 바깥 주황 원
            Circle()
                .trim(from: 0.0, to: clamped)
                .stroke(
                    .orange05,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 145, height: 145)
                .rotationEffect(.degrees(-90))
        }
    }
}
#Preview {
    // 연동된 값: 780 / 1000 = 78%
    CalorieGaugeWorkoutView(percentage: 0.78)
}
