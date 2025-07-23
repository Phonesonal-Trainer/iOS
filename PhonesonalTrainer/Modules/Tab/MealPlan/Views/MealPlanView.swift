//
//  MealPlanView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/14/25.
//
/// 배경색 회색...
/// StickyHeader 어디를 기준으로 구현?  -> 구현 안 하기로 결정.
import SwiftUI

struct MealPlanView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    @StateObject private var viewModel = MealPlanViewModel()
    @State private var path = NavigationPath()  // 식단 기록 상세로 가기 위해
    
    // MARK: - Constants
    fileprivate enum MealPlanConstants {
        static let scrollViewSpacing: CGFloat = 25
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                VStack {
                    Text("식단 플랜")
                        .font(.PretendardMedium22)
                        .foregroundStyle(.grey05)
                        .padding(.bottom, 20)
                    
                    WeeklyCalendarView()
                    
                    /// 일단 divider 로 구현해둠
                    Divider()
                }
                
                ScrollView {
                    VStack(spacing: MealPlanConstants.scrollViewSpacing) {
                        // 총 섭취 칼로리
                        caloriesSectionView
                        
                        // 식단 세그먼트
                        MealTypeSegmentView()
                        
                        // 식단 플랜 뷰
                        MealListView()
                        
                        // 식단 기록 뷰
                        MealRecordSectionView(viewModel: viewModel) { selectedType in
                            path.append(MealPlanRoute.mealRecordDetail(selectedType))
                        }
                    }
                }
            }
            .navigationDestination(for: MealPlanRoute.self) { route in
                            switch route {
                            case .mealRecordDetail(let mealType):
                                MealRecordDetailView(mealType: mealType)
                            }
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
                Text("1234 kcal")
                    .font(.PretendardSemiBold22)
                    .foregroundStyle(.grey05)
                Text("/")
                    .font(.PretendardMedium16)
                    .foregroundStyle(.orange05)
                Text("1111 kcal")
                    .font(.PretendardMedium16)
                    .foregroundStyle(.orange05)
            }
        }
        .padding(.leading, 26)
        .padding(.trailing, screenWidth > 400 ? 188 : 60)
    }
}

#Preview {
    MealPlanView()
}
