//
//  FoodSearchView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/25/25.
//

import SwiftUI

struct FoodSearchView: View {
    
    // MARK: - Property
    @StateObject private var viewModel = FoodSearchViewModel()
    
    // MARK: - 상수 정의
    fileprivate enum FoodSearchConstants {
        static let baseWidth: CGFloat = 340  // 기본적으로 전부 적용되는 너비
        static let VSpacing: CGFloat = 25
        static let noticeHeight: CGFloat = 60 // notice 이미지 높이
        static let pageNavigationHSpacing: CGFloat = 10
    }
    
    /// '저장하기' 버튼 활성화 조건  ->  선택한 음식이 하나는 있어야 함.
    private var isValid: Bool {
        !viewModel.selectedMealIDs.isEmpty
    }
    
    /// '저장하기' 버튼 색상
    var saveButtonColor: Color {
        isValid ? .grey05 : .grey01
    }
    
    /// '저장하기' 버튼 텍스트 색상
    var saveButtonTextColor: Color {
        isValid ? .grey00 : .grey02
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            topTitle  // grey00 으로 배경
                .background(Color.grey00)
            
            ScrollView {
                VStack(spacing: FoodSearchConstants.VSpacing) {
                    /// 서치바 + 정렬 선택 세그먼트 + 음식 그리드
                    middleContent
                    
                    /// notice 이미지
                    notice
                    
                    // 저장 버튼
                    MainButton(color: saveButtonColor, text: "저장하기", textColor: saveButtonTextColor) {
                        if isValid {
                            // 선택한 음식 정보 저장
                        }
                    }
                    .disabled(!isValid)
                    .frame(width: FoodSearchConstants.baseWidth)
                }
            }
            
        }
    }
    
    // MARK: - 상단 타이틀
    private var topTitle: some View {
        BackHeader(title: "식단 검색") {   // 근데 오른쪽에 '직접 추가' 버튼도 추가해야되는데..
            // 뒤로가기 로직
        }
    }
    
    // MARK: - 중간 식단 검색 부분
    private var middleContent: some View {
        VStack(spacing: FoodSearchConstants.VSpacing) {
            CustomSearchBar(text: $viewModel.searchText, placeholder: "식단 검색")
            
            // 정렬 선택
            sortSegment
            
            // 식단 그리드 부분
            foodGridView
            
            // 페이지네이션
            pageNavigation
        }
    }
    
    // MARK: - 정렬 Segment
    private var sortSegment: some View {
        HStack {
            Spacer()  // 방법이 이거밖에 없으려나
            
            Button(action: { viewModel.selectSort(.frequency) }) {
                Text("빈도 높은 순")
                    .font(.PretendardMedium12)
                    .foregroundColor(viewModel.selectedSort == .frequency ? .grey03 : .grey02)
            }
            Rectangle()
                .fill(Color.grey02)
                .frame(width: 1, height: 8)
                
            Button(action: { viewModel.selectSort(.favorite) }) {
                Text("즐겨찾기 순")
                    .font(.PretendardMedium12)
                    .foregroundColor(viewModel.selectedSort == .favorite ? .grey03 : .grey02)
            }
        }
        .frame(width: FoodSearchConstants.baseWidth)
    }
    
    // MARK: - 음식 아이템 그리드 뷰
    private var foodGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
            ForEach(viewModel.pagedFoods) { item in
                FoodCard(item: item, viewModel: viewModel)
            }
        }
        .frame(width: FoodSearchConstants.baseWidth)
    }
    
    // MARK: - 페이지네이션
    private var pageNavigation: some View {
        HStack(spacing: FoodSearchConstants.pageNavigationHSpacing) {
            Button(action: { viewModel.goToPreviousPage() }) {
                Image(systemName: "chevron.left")
            }
            .disabled(viewModel.currentPage == 1)
            
            
            Button(action: { viewModel.goToNextPage() }) {
                Image(systemName: "chevron.right")
            }
            .disabled(viewModel.currentPage >= viewModel.totalPages)
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Notice
    private var notice: some View {
        Image("mealSearchNotice")
            .resizable()
            .frame(width: FoodSearchConstants.baseWidth, height: FoodSearchConstants.noticeHeight)
    }
}

#Preview {
    FoodSearchView()
}
