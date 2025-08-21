//
//  MealPlanView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/14/25.
//


import SwiftUI

struct MealPlanView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    @Binding var path: [MealPlanRoute]
    @State private var selectedDate: Date = Date()
    @StateObject private var viewModel = MealPlanViewModel()
    @StateObject private var favoritesStore = FavoritesStore()
    
    // MARK: - Constants
    fileprivate enum MealPlanConstants {
        static let scrollViewSpacing: CGFloat = 25
    }
    
    var body: some View {
        let type = viewModel.selectedType
        
        VStack(spacing: 0) {   // spacing을 0으로 주면 scrollview가 깔끔해짐.
            VStack {
                Text("식단 플랜")
                    .font(.PretendardMedium22)
                    .foregroundStyle(.grey05)
                    .padding(.bottom, 20)
                
                WeeklyCalendarView(selectedDate: $selectedDate)
                
                /// 일단 divider 로 구현해둠
                Divider()
            }
            .background(Color.grey00)
            .zIndex(1)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: MealPlanConstants.scrollViewSpacing) {
                    // 총 섭취 칼로리
                    caloriesSectionView
                    
                    // 식단 세그먼트
                    MealTypeSegmentView(selectedMeal: $viewModel.selectedType)
                    
                    // 식단 플랜 뷰  -> 간식이면 생략
                    if viewModel.selectedType != .snack {
                        MealListView(selectedDate: $selectedDate, selectedMeal: viewModel.selectedType)
                    }
                    
                    // 식단 기록 뷰 (그대로 노출)
                    MealRecordSectionView(viewModel: viewModel, path: $path)
                }
            }
        }
        .background(Color.background)
        .navigationDestination(for: MealPlanRoute.self) { route in
            switch route {
            case .mealRecord:
                if let model = viewModel.item(for: viewModel.selectedType) {
                    MealRecordDetailView(
                        mealType: type,
                        selectedDate: selectedDate, model: model,
                        planVM: viewModel,
                        path: $path,
                        favoritesStore: favoritesStore
                    )
                } else {
                    // 모델이 없으면 비어있는 상태 보여주기
                    Text("이 날짜엔 기록이 없어요.")
                }
            case .foodSearch:
                FoodSearchView(path: $path, favorites: favoritesStore, selectedDate: selectedDate, mealType: viewModel.selectedType)
            case .manualAdd:
                ManualAddMealView(
                    selectedDate: selectedDate,
                    mealType: viewModel.selectedType,
                    token: nil // 필요 시 전달
                )
            }
        }
    }
    
    private var caloriesSectionView: some View {   // 일단 더미 데이터로 구현해둠. 나중에 백엔드랑 연결.
        VStack(alignment: .leading){
            Text("총 섭취 칼로리")
                .font(.PretendardRegular14)
                .foregroundStyle(.grey03)
                .padding(.top, 25)
            
            HStack {
                Text("\(Int(viewModel.actualTotalKcal).formattedWithSeparator) kcal")
                    .font(.PretendardSemiBold22)
                    .foregroundStyle(.grey05)
                Text("/")
                    .font(.PretendardMedium16)
                    .foregroundStyle(.orange05)
                Text("\(Int(viewModel.plannedTotalKcal).formattedWithSeparator) kcal")
                    .font(.PretendardMedium16)
                    .foregroundStyle(.orange05)
            }
        }
        .padding(.leading, 26)
        .padding(.trailing, screenWidth > 400 ? 188 : 60)
    }
}

#Preview {
    StatefulPreviewWrapper([MealPlanRoute]()) { path in
        MealPlanView(path: path)
    }
}
