//
//  CalorieProgressWorkoutView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/28/25.
//

import SwiftUI

struct CalorieProgressWorkoutView: View {
    @ObservedObject var viewModel: CalorieProgressWorkoutViewModel

    var body: some View {
        HStack(spacing: 16) {
            // ✅ 0.0 ~ 9.99 Double 값으로 넘김
            CalorieGaugeWorkoutView(percentage: viewModel.percentage)

            VStack(alignment: .leading, spacing: 6) {
                            // 라벨
                            Text("소모 칼로리")
                                .font(.subheadline)
                                .foregroundStyle(.grey04)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text(viewModel.kcal.formattedWithSeparator)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.grey04)

                                    Text("kcal")
                                        .font(.subheadline)
                                        .foregroundStyle(.grey04)
                                }

                                // 🔸 슬래시 / 목표 kcal
                                HStack(spacing: 2) {
                                    Text("/")
                                        .font(.subheadline)
                                        .foregroundStyle(.grey04)

                                    Text(viewModel.goal.formattedWithSeparator)
                                        .font(.subheadline)
                                        .foregroundStyle(.grey04)

                                    Text("kcal")
                                        .font(.subheadline)
                                        .foregroundStyle(.grey04)
                                }

                // ✅ 부족/초과 박스
                if viewModel.badgeText.contains("부족") || viewModel.badgeText.contains("초과") {
                    Text(viewModel.badgeText)
                        .font(.system(size: 12))
                        .foregroundColor(.orange05)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange01)
                        .cornerRadius(30)
                        .frame(width: 96, height: 22)
                }
            }
        }
    }
}

#Preview {
    // 연동 테스트용 뷰모델 (780 / 1000 = 78%)
    let vm = CalorieProgressWorkoutViewModel(kcal: 1100, goal: 1000)
    CalorieProgressWorkoutView(viewModel: vm)
}
