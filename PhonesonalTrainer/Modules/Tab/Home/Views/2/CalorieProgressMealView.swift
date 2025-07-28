//
//  CalorieProgressMealView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/28/25.
//
import SwiftUI

struct CalorieProgressMealView: View {
    @ObservedObject var viewModel: CalorieProgressMealViewModel

    var body: some View {
        HStack(spacing: 16) {
            // 식단 게이지
            CalorieGaugeMealView(percentage: Double(viewModel.percentage) / 100.0)

            VStack(alignment: .leading, spacing: 6) {
                Text("섭취 칼로리")
                    .font(.caption)
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
                let vm = CalorieProgressMealViewModel(kcal: 1234, goal: 2345)
                CalorieProgressMealView(viewModel: vm)
            }

