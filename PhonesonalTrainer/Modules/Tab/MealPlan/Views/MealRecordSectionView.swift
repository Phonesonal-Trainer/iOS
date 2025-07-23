//
//  MealRecordSectionView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/21/25.
//

import SwiftUI

// MARK: - Constants(상수 정의)
fileprivate enum MealRecordConstants {
    static let recordSectionWidth: CGFloat = 340
    static let emptyMealRecordHeight: CGFloat = 57
    static let recordInfoHeight: CGFloat = 118
}

struct MealRecordSectionView: View {
    @ObservedObject var viewModel: MealPlanViewModel
    
    // MARK: - Body
    var body: some View {
        let type = viewModel.selectedType
        let state = viewModel.mealRecordState(for: type)
        
        VStack(alignment: .leading, spacing: 16) {
            Text("식단 기록")
                .font(.PretendardSemiBold16)

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
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 0)
            
            NutritionInfoCard(nutrition: NutritionInfoModel(mealType: "아침", kcal: 1234, carb: 111, protein: 111, fat: 111))
        }
    }
}

/// 기록 O, 이미지 O
struct RecordWithImageView: View {
    var body: some View {
        
    }
}

#Preview {
    let viewModel = MealPlanViewModel()
        viewModel.mealRecordStates[.breakfast] = .noImage // 강제 설정

        return MealRecordSectionView(viewModel: viewModel)
}
