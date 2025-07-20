//
//  MealListView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/20/25.
//

import SwiftUI

struct MealListView: View {
   @StateObject private var mealviewModel = MealListViewModel()
    
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
                    MealListCard(item: meal)
                                
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
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .frame(width: MealListConstants.mealListWidth)
        }
    }
}

#Preview {
    MealListView()
}
