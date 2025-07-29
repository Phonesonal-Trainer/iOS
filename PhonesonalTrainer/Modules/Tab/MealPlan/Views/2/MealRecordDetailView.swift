//
//  MealRecordDetailView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/23/25.
//

import SwiftUI

struct MealRecordDetailView: View {
    // MARK: - Property
    let mealType: MealType // 추후 model이나 viewModel을 넣는 것을 고려
    @StateObject private var viewModel = AddedMealViewModel()
    @State private var selectedMeal: MealModel? = nil  // 팝업 되는 식단
    @State private var showPopup: Bool = false
    @Environment(\.dismiss) private var dismiss  // 뒤로가기 액션
    
    // MARK: - 상수 정의
    fileprivate enum MealRecordDetailConstant {
        static let basicWidth: CGFloat = 340
        static let vSpacing: CGFloat = 25
        static let addedMealVSpacing: CGFloat = 20  // 추가 식단 vspacing
        static let searchBarTextWidth: CGFloat = 300
        static let magnifyingglassIconSize: CGFloat = 24
        static let searchBarWidth: CGFloat = 340
        static let searchBarHeight: CGFloat = 44
        static let addedMealListVSpacing: CGFloat = 10
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    // 상단 NavigationBar
                    NavigationBar(title: "\(mealType.rawValue) 식단 기록") {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.PretendardMedium22)
                                .foregroundStyle(Color.grey05)
                        }
                    }
                    .background(Color.grey00)
                    .shadow(color: Color.black.opacity(0.1), radius: 2)
                    .zIndex(1)
                    
                    ScrollView {
                        VStack(spacing: MealRecordDetailConstant.vSpacing) {
                            // 이미지 업로드 (서버에 업로드) -> 공용 컴포넌트 고려
                            ImageUpload()
                                .padding(.top, MealRecordDetailConstant.vSpacing)
                            
                            RecordInfoView()
                            
                            MealCheckListView()
                            
                            addedMealSection
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        viewModel.fetchMeals(for: mealType) // 뷰가 화면에 보일 때 서버에서 식단 데이터를 불러옴
                    }
                    .background(Color.background)
                }
                .navigationBarBackButtonHidden(true) // 기본 NavigationBackButton 숨김
                
                //팝업 로직..
            }
            
        }
    }
    
    // MARK: - 추가 식단 영역
    private var addedMealSection: some View {
        VStack(alignment: .leading, spacing: MealRecordDetailConstant.addedMealVSpacing) {
            Text("추가 식단")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
            
            NavigationLink(destination: FoodSearchView()) {
                searchBar
            }
            
            VStack{
                if viewModel.addedMeals.isEmpty {
                    Text("아직 추가된 식단이 없습니다.")
                        .font(.PretendardMedium16)
                        .foregroundStyle(Color.grey02)
                        .padding(.top, 20)
                } else {
                    VStack(spacing: MealRecordDetailConstant.addedMealListVSpacing){
                        ForEach(viewModel.addedMeals) { meal in
                            SwipeToDeleteMealRow(meal: meal) {
                                viewModel.deleteMeal(meal)
                            }
                            .onTapGesture {
                                selectedMeal = meal
                                showPopup = true
                            }
                        }
                    }
                    
                }
            }
            
        }
    }
    
    // MARK: - 서치 바 버튼
    private var searchBar: some View {
        HStack {
            Text("식단 검색")
                .font(.PretendardMedium16)
                .foregroundStyle(Color.grey02)
            
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.grey05)
                .frame(width: MealRecordDetailConstant.magnifyingglassIconSize, height: MealRecordDetailConstant.magnifyingglassIconSize)
        }
        .frame(width: MealRecordDetailConstant.searchBarTextWidth)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.grey01)
                .frame(width: MealRecordDetailConstant.searchBarWidth, height: MealRecordDetailConstant.searchBarHeight)
        )
    }
}



// MARK: - 스와이프 하면 삭제 되는 식단 리스트
struct SwipeToDeleteMealRow: View {
    let meal: MealModel
    var onDelete: () -> Void
    
    fileprivate enum Constants {
        static let textVSpacing: CGFloat = 2
        static let textWidth: CGFloat = 300
        static let textHeight: CGFloat = 35
        static let width: CGFloat = 340
        static let height: CGFloat = 65
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Constants.textVSpacing){
                Text(meal.name)
                    .font(.PretendardSemiBold16)
                    .foregroundStyle(Color.grey05)
                
                Text("\(meal.amount)g")
                    .font(.PretendardMedium12)
                    .foregroundStyle(Color.grey02)
            }
            
            Spacer()
            
            Text("\(meal.kcal) kcal")
                .font(.PretendardMedium16)
                .foregroundStyle(Color.grey05)
        }
        .frame(width: Constants.textWidth, height: Constants.textHeight)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.grey00)
                .frame(width: Constants.width, height: Constants.height)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
        )
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onDelete) {
                Text("삭제")
                    .font(.PretendardMedium18)
                    .foregroundStyle(Color.orange05)
            }
        }
    }
}

#Preview {
    MealRecordDetailView(mealType: .breakfast)
}
