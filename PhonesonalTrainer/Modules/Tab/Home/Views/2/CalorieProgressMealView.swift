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
                        .font(.system(size: 14))
                        .foregroundColor(.grey05)
                        .frame(height: 17)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(viewModel.kcal.formattedWithSeparator)
                            .font(.system(size: 28))
                            .fontWeight(.semibold)
                            .foregroundStyle(.grey05)
                        
                        Text("kcal")
                            .font(.system(size: 16))
                            .foregroundStyle(.grey02)
                    }
                    
                    
                    HStack(spacing: 2) {
                        Text("/")
                            .font(.system(size: 16))
                            .foregroundColor(.grey02)

                        Text(viewModel.goal.formattedWithSeparator)
                            .font(.system(size: 16))
                            .foregroundStyle(.grey03)

                        Text("kcal")
                            .font(.system(size: 16))
                            .foregroundStyle(.grey03)
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

