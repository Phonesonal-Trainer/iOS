//
//  NutritionInfoCard.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/22/25.
//

import SwiftUI

struct NutritionInfoCard: View {
    
    let nutrition: NutritionInfoModel
    
    @StateObject private var viewModel = NutritionInfoViewModel()
    
    // MARK: - 상수 정의
    fileprivate enum NutritionInfoConstants {
        static let vSpacing: CGFloat = 15
        static let textHSpacing: CGFloat = 10
        static let textVSpacing: CGFloat = 5
        static let textHPadding: CGFloat = 25
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: NutritionInfoConstants.vSpacing) {
            mealTypeAndKcalText  // 상단: 식사 타입과 섭취 칼로리 텍스트
            
            HStack {   // 하단: 탄단지 항목
                carbProteinFat(title: "탄수화물", value: nutrition.carb)
                    .padding(.trailing, NutritionInfoConstants.textHPadding)
                divider()
                carbProteinFat(title: "단백질", value: nutrition.protein)
                    .padding(.leading, NutritionInfoConstants.textHPadding)
                    .padding(.trailing, NutritionInfoConstants.textHPadding)
                divider()
                carbProteinFat(title: "지방", value: nutrition.fat)
                    .padding(.leading, NutritionInfoConstants.textHPadding)
            }
        }
    }
    
    // MARK: - 식사 타입과 섭취 칼로리 텍스트 뷰
    private var mealTypeAndKcalText: some View {
        HStack(spacing: NutritionInfoConstants.textHSpacing, content: {
            Text("\(nutrition.mealType ?? "") 섭취 칼로리")
                .font(.PretendardMedium16)
                .foregroundStyle(Color.grey05)
            Text("\(nutrition.kcal)kcal")
                .font(.PretendardSemiBold16)
                .foregroundStyle(Color.orange05)
        })
    }
    
    // MARK: - 탄단지 항목 뷰
    private func carbProteinFat(title: String, value: Int) -> some View {
        VStack(spacing: NutritionInfoConstants.textVSpacing, content: {
            Text(title)
                .font(.PretendardRegular14)
                .foregroundStyle(Color.grey03)
            Text("\(value)g")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey05)
        })
        
    }
    
    // MARK: - 세로선
    private func divider() -> some View {
        Rectangle()
            .fill(Color.line)
            .frame(width: 1, height: 30)
    }
}

#Preview {
    NutritionInfoCard(nutrition: NutritionInfoModel(mealType: "아침", kcal: 1234, carb: 111, protein: 111, fat: 111))
}
