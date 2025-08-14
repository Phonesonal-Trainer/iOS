//
//  AddedMealSectionView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/30/25.
//

import SwiftUI

extension Notification.Name {
    static let userMealsDidChange = Notification.Name("UserMealsDidChange")
}

struct AddedMealSectionView: View {
    @ObservedObject var viewModel: AddedMealViewModel
    @Binding var path: [MealPlanRoute]
    
    // 바인딩으로 상태 전달 받기
    @Binding var selectedMealViewModel: MealInfoViewModel?
    @Binding var showPopup: Bool
    @Binding var showDeletePopup: Bool
    
    // 조회 파라미터
    @Binding var selectedDate: Date
    let mealType: MealType
    
    @Binding var pendingDelete: MealRecordEntry?
    
    // MARK: - 상수 정의
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
    
    // MARK: - Body
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
            if viewModel.isLoading {
                ProgressView().padding(.vertical, 10)
            } else if let msg = viewModel.errorMessage {
                Text(msg)
                    .font(.PretendardMedium14)
                    .foregroundStyle(Color.red)
                    .padding(.vertical, 10)
            } else if viewModel.addedMeals.isEmpty {
                EmptyView()
            } else {
                addedMeal
            }
        }
        .frame(maxWidth: AddedMealSectionConstants.basicWidth)
        .task { await viewModel.load(date: selectedDate, mealType: mealType) }
        .onChange(of: selectedDate) {
            Task {
                await viewModel.load(date: selectedDate, mealType: mealType)
            }
        }
        .onChange(of: mealType) {
            Task {
                await viewModel.load(date: selectedDate, mealType: mealType)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .userMealsDidChange)) { _ in
            Task { await viewModel.load(date: selectedDate, mealType: mealType) }
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
                            selectedMealViewModel = MealInfoViewModel(entry: entry, isFavorite: false)
                            withAnimation {
                                showPopup = true
                            }
                        }
                        
                    
                    Button {
                        pendingDelete = entry
                        withAnimation {
                            showDeletePopup = true
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: AddedMealSectionConstants.deleteButtonSize,
                                   height: AddedMealSectionConstants.deleteButtonSize)
                            .foregroundStyle(
                                viewModel.deleting.contains(entry.recordId) ? Color.grey03 : Color.orange05
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.deleting.contains(entry.recordId))
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

