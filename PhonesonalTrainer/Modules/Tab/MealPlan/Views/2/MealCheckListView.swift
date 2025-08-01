//
//  MealCheckListView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/23/25.
//

/// 추후에 구현해야 하는 기능:
/// 선택한 항목의 양과 칼로리 기억해서 합산하는데에 사용.
/// 선택한 항목들 기억해두기. -> 나중에 사용자가 다시 해당 식단 기록 상세 뷰에 들어왔을 때 저장되어 있게.... 
import SwiftUI

struct MealCheckListView: View {
    @StateObject private var mealviewModel = MealListViewModel()
    @StateObject private var viewModel = MealCheckListViewModel()
    
    // MARK: - Constants(상수 정의)
    fileprivate enum MealListConstants {
        static let mealCardLeadingPadding: CGFloat = 20
        static let mealCardTrailingPadding: CGFloat = 20
        static let mealCardTopPadding: CGFloat = 10
        static let mealCardBottomPadding: CGFloat = 10
        static let mealListWidth: CGFloat = 340
        static let mealListHeight: CGFloat = 215
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("식단 플랜")
                .font(.PretendardMedium18)
                .foregroundStyle(.grey06)
            
            VStack(spacing: 0) {
                ForEach(Array(mealviewModel.mealItems.enumerated()), id: \.1.id) { index, meal in
                    MealCheckboxCard(item: meal, viewModel: viewModel)
                                
                    if index != mealviewModel.mealItems.count - 1 {
                        Divider()
                        
                    }
                }
                .padding(.leading, MealListConstants.mealCardLeadingPadding)
                .padding(.trailing, MealListConstants.mealCardTrailingPadding)
            }
            .padding(.top, MealListConstants.mealCardTopPadding)
            .padding(.bottom, MealListConstants.mealCardBottomPadding)
            .background(Color.white)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            .frame(width: MealListConstants.mealListWidth)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MealCheckListView()
}
