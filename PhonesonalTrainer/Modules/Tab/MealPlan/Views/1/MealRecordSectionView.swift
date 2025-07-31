//
//  MealRecordSectionView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/21/25.
//

import SwiftUI

// MARK: - Constants(상수 정의)
fileprivate enum MealRecordConstants {
    static let titleHSpacing: CGFloat = 8   // '식단 기록' 과 '>' 사이
    static let arrowSize: CGFloat = 18   // 식단 기록 상세 가기 버튼('>') 사이즈
    
    static let recordSectionWidth: CGFloat = 340   // 박스 공통 너비
    static let emptyMealRecordHeight: CGFloat = 57    // 기록 없음 높이
    static let recordInfoHeight: CGFloat = 118     // 이미지 없는 기록 높이
}

struct MealRecordSectionView: View {
    @ObservedObject var viewModel: MealPlanViewModel
    @Binding var path: [MealPlanRoute]
    
    
    // MARK: - Body
    var body: some View {
        let type = viewModel.selectedType
        let state = viewModel.mealRecordState(for: type)
        
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: MealRecordConstants.titleHSpacing, content: {
                Text("식단 기록")
                    .font(.PretendardMedium18)
                    .foregroundStyle(Color.grey06)
                
                Button(action: {
                    path.append(.mealRecord)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.grey05)
                        .frame(width: MealRecordConstants.arrowSize, height: MealRecordConstants.arrowSize)
                }
            })
            
            switch state {
            case .none:
                EmptyMealRecordView()
            case .noImage:
                RecordInfoView()
            case .withImage:
                RecordWithImageView()
            }
        }
        .padding(.horizontal)
    }
}


/// 기록 X
struct EmptyMealRecordView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color(.grey01))
            .frame(width: MealRecordConstants.recordSectionWidth, height: MealRecordConstants.emptyMealRecordHeight)
            .overlay(
                Text("아직 기록 전이에요.")
                    .font(.PretendardRegular14)
                    .foregroundStyle(Color(.grey03))
            )
    }
}

/// 기록 O, 이미지 X
struct RecordInfoView: View {
    var body: some View {
        /// 기록 상세 화면에서도 등장하는 화면
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(.grey00))
                .frame(width: MealRecordConstants.recordSectionWidth, height: MealRecordConstants.recordInfoHeight)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
            
            NutrientInfoCard(Nutrient: NutrientInfoModel(mealType: "아침", kcal: 1234, carb: 111, protein: 111, fat: 111))
        }
    }
}

/// 기록 O, 이미지 O
struct RecordWithImageView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(.grey00))
                .frame(width: MealRecordConstants.recordSectionWidth)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
            
            NutrientInfoCard(Nutrient: NutrientInfoModel(mealType: "아침", kcal: 1234, carb: 111, protein: 111, fat: 111))
            //NutrientInfoCard 에 이미지 추가할까 어떻게 구현하지 걍 아예 새로 해야되나
        }
    }
}

