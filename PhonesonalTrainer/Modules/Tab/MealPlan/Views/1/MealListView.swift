//
//  MealListView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/20/25.
//

import SwiftUI

struct MealListView: View {
    @Binding var selectedDate: Date
    let selectedMeal: MealType
    
    @StateObject private var viewModel = MealListViewModel()
    
    
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
            
            if viewModel.isLoading {
                ProgressView().frame(height: MealListConstants.mealListHeight)
            } else if let msg = viewModel.errorMessage {
                Text(msg).foregroundStyle(.red)
            }
            
            VStack(spacing: 0) {
                ForEach(Array(viewModel.mealItems.enumerated()), id: \.1.id) { index, meal in
                    MealImageOptionCard(item: meal, showImage: true)
                                
                    if index != viewModel.mealItems.count - 1 {
                        Divider()
                        
                    }
                }
                .padding(.leading, MealListConstants.mealCardLeadingPadding)
                .padding(.trailing, MealListConstants.mealCardTrailingPadding)
            }
            .padding(.top, MealListConstants.mealCardTopPadding)
            .padding(.bottom, MealListConstants.mealCardBottomPadding)
            .background(Color.grey00)
            .cornerRadius(5)
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            .frame(width: MealListConstants.mealListWidth)
        }
        .task { await viewModel.load(date: selectedDate, mealType: selectedMeal) }
        .onChange(of: selectedMeal) { _ in Task { await viewModel.load(date: selectedDate, mealType: selectedMeal) } }
        .onChange(of: selectedDate) { _ in Task { await viewModel.load(date: selectedDate, mealType: selectedMeal) } }
    }
}


