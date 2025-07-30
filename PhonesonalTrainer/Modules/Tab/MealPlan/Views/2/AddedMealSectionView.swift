//
//  AddedMealSectionView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/30/25.
//

import SwiftUI

struct AddedMealSectionView: View {
    @ObservedObject var viewModel: AddedMealViewModel
    
    fileprivate enum AddedMealSectionConstants {
        static let VSpacing: CGFloat = 20
        static let horizontalPadding: CGFloat = 25
        static let magnifyingglassIconSize: CGFloat = 24
        static let searchBarPadding: CGFloat = 20
        static let searchBarHeight: CGFloat = 44
        static let addedMealListVSpacing: CGFloat = 10
        static let mealCardHorizontalPadding: CGFloat = 20
        static let mealCardHeight: CGFloat = 65
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AddedMealSectionConstants.VSpacing) {
            Text("추가 식단")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
                
            NavigationLink(destination: FoodSearchView()) {
                searchBar
            }
            
            if !viewModel.addedMeals.isEmpty {
                List {
                    ForEach(viewModel.addedMeals) { meal in
                        MealListCard(item: meal, showImage: false, showCheckbox: false, viewModel: nil)
                            .listRowBackground(Color.grey00) // 개별 셀 배경
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.deleteMeal(meal)
                                } label: {
                                    Text("삭제")
                                }
                                .tint(Color.orange05) // 원하는 색상으로 설정
                            }
                    }
                }
                .listStyle(.plain) // separator 및 기본 스타일 제거
                .clipShape(RoundedRectangle(cornerRadius: 12)) // 모서리 둥글게
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2) // 그림자
            } 
        }
        .padding(.horizontal, AddedMealSectionConstants.horizontalPadding)
        
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
        .frame(maxWidth: .infinity)
    }
}

