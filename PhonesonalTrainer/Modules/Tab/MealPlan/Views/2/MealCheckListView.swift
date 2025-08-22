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
    @Binding var selectedDate: Date
    let mealType: MealType
    
    @StateObject private var listVM = MealListViewModel()
    @ObservedObject var checkVM : MealCheckListViewModel
    
    // 숨김 여부
    private var shouldHide: Bool {
        DietPlanVisibility.shouldHide(date: selectedDate) || mealType == .snack
    }
    
    // MARK: - Constants(상수 정의)
    fileprivate enum MealListConstants {
        static let mealCardHPadding: CGFloat = 20
        static let mealCardVPadding: CGFloat = 10
        static let mealListWidth: CGFloat = 340
        static let mealListHeight: CGFloat = 215
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if !shouldHide {
                Text("식단 플랜")
                    .font(.PretendardMedium18)
                    .foregroundStyle(.grey06)
                
                VStack(spacing: 0) {
                    ForEach(Array(listVM.mealItems.enumerated()), id: \.1.id) { _, meal in
                        MealCheckboxCard(item: meal, selectedDate: selectedDate, mealType: mealType, viewModel: checkVM)
                                    
                        if meal.id != listVM.mealItems.last?.id { Divider() }
                                        
                    }
                    .padding(.horizontal, MealListConstants.mealCardHPadding)
                }
                .padding(.vertical, MealListConstants.mealCardVPadding)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
                .frame(width: MealListConstants.mealListWidth)
            }
        }
        .frame(maxWidth: .infinity)
        .task {
            if !shouldHide {
                await listVM.load(date: selectedDate, mealType: mealType)
                checkVM.syncSelection(from: listVM.mealItems)
            }
        }
        .onChange(of: selectedDate) {
            Task {
                if !shouldHide {
                    await listVM.load(date: selectedDate, mealType: mealType)
                    checkVM.syncSelection(from: listVM.mealItems)
                }
            }
        }
        .onChange(of: mealType) {
            Task {
                if !shouldHide {
                    await listVM.load(date: selectedDate, mealType: mealType)
                    checkVM.syncSelection(from: listVM.mealItems)
                }
            }
        }
    }
}

// #Preview {
//     MealCheckListView()
// }
