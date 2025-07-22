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
    var body: some View {
        VStack {
            HStack(spacing: NutritionInfoConstants.textHSpacing, content: {
                Text("\(nutrition.mealType ?? "") 섭취 칼로리")
                    .font(.PretendardMedium16)
                    .foregroundStyle(Color.grey05)
                Text("\(nutrition.kcal)kcal")
                    .font(.PretendardSemiBold16)
                    
            })
        }
    }
}

#Preview {
    NutritionInfoCard(nutrition: NutritionInfoModel(mealType: "아침", kcal: 1234, carb: 111, protein: 111, fat: 111))
}
