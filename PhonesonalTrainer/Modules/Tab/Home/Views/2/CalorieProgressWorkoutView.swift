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
            CalorieGaugeWorkoutView(percentage: viewModel.percentage)

            VStack(alignment: .leading, spacing: 6) {
                // 🔹 라벨
                Text("소모 칼로리")
                    .font(.system(size: 14)) 
                    .foregroundColor(.grey05)
                    .frame(height: 17)

                // 🔹 실제 소모 칼로리 (숫자 + kcal)
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(viewModel.kcal.formattedWithSeparator)
                        .font(.system(size: 28)) 
                        .fontWeight(.semibold)
                        .foregroundColor(.grey05)

                    Text("kcal")
                        .font(.system(size: 16))
                        .foregroundColor(.grey02)
                }
                .frame(height: 34)

                // 🔹 / 목표칼로리 kcal
                HStack(spacing: 2) {
                    Text("/")
                        .font(.system(size: 16))
                        .foregroundColor(.grey02)

                    Text(viewModel.goal.formattedWithSeparator)
                        .font(.system(size: 16))
                        .foregroundColor(.grey03)

                    Text("kcal")
                        .font(.system(size: 16))
                        .foregroundColor(.grey03)
                }
                .frame(height: 19)

                // 🔸 부족 or 초과 뱃지
                if viewModel.badgeText.contains("부족") || viewModel.badgeText.contains("초과") {
                    Text(viewModel.badgeText)
                        .font(.custom("Pretendard-Medium", size: 12))
                        .foregroundColor(.orange05)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange01)
                        .cornerRadius(30)
                        .frame(width: 96, height: 22)
                        .multilineTextAlignment(.center) // 중앙 정렬 추가 
                }
            }
            .frame(width: 108) // 전체 박스 정렬 기준

                }
            }
        }
    

#Preview {
    // 연동 테스트용 뷰모델 (780 / 1000 = 78%)
    let vm = CalorieProgressWorkoutViewModel(kcal: 1100, goal: 1000)
    CalorieProgressWorkoutView(viewModel: vm)
}
