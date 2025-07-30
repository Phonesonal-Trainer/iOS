//
//  NutrientInfoCard.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/22/25.
//

import SwiftUI

struct NutrientInfoCard: View {
    
    let Nutrient: NutrientInfoModel
    
    @StateObject private var viewModel = NutrientInfoViewModel()
    
    // MARK: - 상수 정의
    fileprivate enum NutrientInfoConstants {
        static let vSpacing: CGFloat = 15
        static let textHSpacing: CGFloat = 10
        static let textVSpacing: CGFloat = 5
        static let textHPadding: CGFloat = 25
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: NutrientInfoConstants.vSpacing) {
            mealTypeAndKcalText  // 상단: 식사 타입과 섭취 칼로리 텍스트
            
            HStack {   // 하단: 탄단지 항목
                carbProteinFat(title: "탄수화물", value: formatToString(Nutrient.carb))
                    .padding(.trailing, NutrientInfoConstants.textHPadding)
                divider()
                carbProteinFat(title: "단백질", value: formatToString(Nutrient.protein))
                    .padding(.leading, NutrientInfoConstants.textHPadding)
                    .padding(.trailing, NutrientInfoConstants.textHPadding)
                divider()
                carbProteinFat(title: "지방", value: formatToString(Nutrient.fat))
                    .padding(.leading, NutrientInfoConstants.textHPadding)
            }
        }
    }
    
    // MARK: - 식사 타입과 섭취 칼로리 텍스트 뷰
    private var mealTypeAndKcalText: some View {
        HStack(spacing: NutrientInfoConstants.textHSpacing, content: {
            Text("\(Nutrient.mealType ?? "") 섭취 칼로리")
                .font(.PretendardMedium16)
                .foregroundStyle(Color.grey05)
            Text("\(formatKcal(Nutrient.kcal))kcal")
                .font(.PretendardSemiBold16)
                .foregroundStyle(Color.orange05)
        })
    }
    
    // MARK: - 탄단지 항목 뷰
    private func carbProteinFat(title: String, value: String) -> some View {
        VStack(spacing: NutrientInfoConstants.textVSpacing, content: {
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
    NutrientInfoCard(Nutrient: NutrientInfoModel(mealType: "아침", kcal: 1234, carb: 111, protein: 111, fat: 111))
}
