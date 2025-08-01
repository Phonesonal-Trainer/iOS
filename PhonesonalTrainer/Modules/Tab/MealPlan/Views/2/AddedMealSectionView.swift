//
//  AddedMealSectionView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/30/25.
//

import SwiftUI

struct AddedMealSectionView: View {
    @ObservedObject var viewModel: AddedMealViewModel
    @Binding var path: [MealPlanRoute]
    
    // 바인딩으로 상태 전달 받기
    @Binding var selectedMealViewModel: MealInfoViewModel?
    @Binding var showPopup: Bool
    
    fileprivate enum AddedMealSectionConstants {
        static let basicWidth: CGFloat = 340
        static let VSpacing: CGFloat = 20
        static let magnifyingglassIconSize: CGFloat = 24
        static let searchBarPadding: CGFloat = 20
        static let searchBarHeight: CGFloat = 44
        static let addedMealListVSpacing: CGFloat = 10
        static let mealCardHorizontalPadding: CGFloat = 20
        static let mealCardWidth: CGFloat = 270
        static let mealCardHeight: CGFloat = 65
        static let deleteButtonSize: CGFloat = 20
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AddedMealSectionConstants.VSpacing) {
            Text("추가 식단")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
                
            Button(action: {
                path.append(.foodSearch)
            }){
                searchBar
            }
            
            // 추가된 식단 리스트
            addedMeal
        }
        .frame(maxWidth: AddedMealSectionConstants.basicWidth)
        
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
                .frame(width: AddedMealSectionConstants.magnifyingglassIconSize, height: AddedMealSectionConstants.magnifyingglassIconSize)
        }
        .padding(.horizontal, AddedMealSectionConstants.searchBarPadding)
        .frame(height: AddedMealSectionConstants.searchBarHeight)
        
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.grey01)
        )
    }
    
    // MARK: - 추가된 식단 리스트
    private var addedMeal: some View {
        VStack(spacing: AddedMealSectionConstants.addedMealListVSpacing) {
            ForEach(viewModel.addedMeals) { entry in
                HStack {
                    MealImageOptionCard(item: entry.meal, showImage: false)  // 텍스트만 있는 카드
                        .padding(.trailing, AddedMealSectionConstants.mealCardHorizontalPadding)
                        .frame(width: AddedMealSectionConstants.mealCardWidth)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedMealViewModel = MealInfoViewModel(meal: entry.meal, nutrient: entry.nutrient, isFavorite: false)
                            withAnimation {
                                showPopup = true
                            }
                        }
                        
                    
                    Button(action: {    // 추가 식단 데이터에서 삭제
                        withAnimation(.easeInOut(duration: 0.3)){
                            viewModel.deleteMeal(entry)
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: AddedMealSectionConstants.deleteButtonSize, height: AddedMealSectionConstants.deleteButtonSize)
                            .foregroundStyle(Color.orange05)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AddedMealSectionConstants.mealCardHorizontalPadding)
                .frame(height: AddedMealSectionConstants.mealCardHeight)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.grey00)
                        .shadow(color: Color.black.opacity(0.1), radius: 2)
                )
                
            }
        }
    }
}

