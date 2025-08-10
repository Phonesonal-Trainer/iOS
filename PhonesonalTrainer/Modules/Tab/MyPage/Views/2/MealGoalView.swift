//
//  MealGoalView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/10/25.
//

import SwiftUI

// API → View용 모델 (표시는 이미 포맷된 문자열로)
struct MealGoalsUIModel {
    let nutrient: String
    let amount: String
}

struct MealGoalView: View {
    let model: MealGoalsUIModel
    
    // MARK: - 상수 (RecommendGoalView와 동일)
    private enum C {
        static let titleToCardSpacing: CGFloat = 20
        static let cardHPad: CGFloat = 20
        static let cardVPad: CGFloat = 20
        static let rowToLineSpacing: CGFloat = 15
        static let lineWidth: CGFloat = 300 // 340 - (좌우 패딩 20*2)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: C.titleToCardSpacing) {
            Text("식단 목표")
                .font(.PretendardMedium20)
                .foregroundStyle(.grey05)
            
            
            VStack(spacing: 0) {
                row("영양소", model.nutrient)
                line.padding(.vertical, C.rowToLineSpacing)

                row("일일 섭취량", model.amount)
            }
            .padding(.vertical, C.cardVPad)
            .padding(.horizontal, C.cardHPad)
            .background(Color.grey00)
            .cornerRadius(5)
        }
        .frame(maxWidth: .infinity)
    }
            
            
    private func row(_ title: String, _ value: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(title)
                    .font(.PretendardMedium16)
                    .foregroundStyle(.grey05)
                    .lineLimit(1)
                    .layoutPriority(2)

                Spacer(minLength: 8)

                Text(value)
                    .font(.PretendardMedium16)
                    .foregroundStyle(.grey05)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .allowsTightening(true)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    private var line: some View {
        Rectangle()
            .fill(Color.line)
            .frame(width: C.lineWidth, height: 1, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MealGoalView(
        model: .init(
            nutrient: "고단백/저지방",
           amount: "1300 ~ 1400 kcal"
        )
    )
}

