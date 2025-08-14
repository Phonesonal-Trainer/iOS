//
//  FoodSearchView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/25/25.
//

import SwiftUI

struct FoodSearchView: View {
    
    // MARK: - Property
    @ObservedObject var favorites: FavoritesStore
    @StateObject private var viewModel : FoodSearchViewModel
    @Environment(\.dismiss) private var dismiss // 뒤로가기
    @Binding var path: [MealPlanRoute]
    
    let selectedDate: Date
    let mealType: MealType
    var token: String? = nil
    
    init(path: Binding<[MealPlanRoute]>, favorites: FavoritesStore, selectedDate: Date, mealType: MealType, token: String? = nil) {
        self._path = path
        self.favorites = favorites
        self.selectedDate = selectedDate
        self.mealType = mealType
        self.token = token
        _viewModel = StateObject(wrappedValue: FoodSearchViewModel(favorites: favorites))
    }

    
    // MARK: - 상수 정의
    fileprivate enum FoodSearchConstants {
        static let baseWidth: CGFloat = 340  // 기본적으로 전부 적용되는 너비
        static let VSpacing: CGFloat = 25
        static let gridHeight: CGFloat = 317
        static let noResultSpacing: CGFloat = 15
        static let noticeHeight: CGFloat = 60 // notice 이미지 높이
        static let pageNavigationHSpacing: CGFloat = 10
        static let addMealButtonWidth: CGFloat = 108
        static let addMealButtonHeight: CGFloat = 28
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
    
    let columns: [GridItem] = Array(repeating: GridItem(.fixed(165), spacing: 15), count: 2)
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // NavigationBar 적용
            topTitle
                .background(Color.grey00)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
                .zIndex(1)
            
            ScrollView {
                VStack(spacing: FoodSearchConstants.VSpacing) {
                    /// 서치바 + 정렬 선택 세그먼트 + 음식 그리드
                    middleContent
                        .padding(.top, FoodSearchConstants.VSpacing)
                    
                    /// notice 이미지
                    notice
                    
                    // 저장 버튼
                    MainButton(
                        color: saveButtonColor,
                        text: "저장하기",
                        textColor: saveButtonTextColor
                    ) {
                        saveAction()
                    }
                    .disabled(!isValid)
                    .frame(width: FoodSearchConstants.baseWidth)
                }
            }
        }
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
        .task { await viewModel.fetchFoods() }
        .onChange(of: viewModel.selectedSort) {
            Task { await viewModel.fetchFoods() }
        }
        .onChange(of: viewModel.searchText) {
            // 간단 디바운스가 필요하면 DispatchQueue.main.asyncAfter로 넣어줘도 OK
            Task { await viewModel.fetchFoods() }
        }
    }
    
    // MARK: - 상단 제목
    private var topTitle: some View {
        NavigationBar(title: "식단 검색") {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
            }
        } trailing: {
            Button(action: {
                path.append(.manualAdd)
            }) {
                Text("직접 추가")
                    .font(.PretendardRegular16)
                    .foregroundColor(.grey05)
            }
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
            Spacer()
            
            Button(action: { viewModel.selectSort(.frequency) }) {
                Text("빈도 높은 순")
                    .font(.PretendardMedium12)
                    .foregroundColor(viewModel.selectedSort == .frequency ? .grey03 : .grey02)
            }
            Rectangle()
                .fill(Color.grey02)
                .frame(width: 1, height: 8)
                
            Button(action: {
                viewModel.selectSort(.favorite)
            }) {
                Text("즐겨찾기 순")
                    .font(.PretendardMedium12)
                    .foregroundColor(viewModel.selectedSort == .favorite ? .grey03 : .grey02)
            }
        }
        .frame(width: FoodSearchConstants.baseWidth)
    }
    
    // MARK: - 음식 아이템 그리드 뷰
    private var foodGridView: some View {
        Group {
            if viewModel.pagedFoods.isEmpty {
                // 검색 결과 없음.
                VStack {
                    Text("검색 결과가 없습니다.")
                        .font(.PretendardMedium16)
                        .foregroundStyle(Color.grey03)
                    
                    Button(action: {
                        path.append(.manualAdd)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.orange05)
                                .frame(width: FoodSearchConstants.addMealButtonWidth, height: FoodSearchConstants.addMealButtonHeight)
                            
                            Text("+ 직접 추가하기")
                                .font(.PretendardMedium12)
                                .foregroundStyle(Color.grey00)
                        }
                    }
                }
                .frame(width: FoodSearchConstants.baseWidth, height: FoodSearchConstants.gridHeight)
            } else {
                // 식단 그리드
                VStack{
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.pagedFoods) { item in
                            FoodCard(item: item, viewModel: viewModel)
                        }
                    }
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .frame(height: FoodSearchConstants.gridHeight)
            }
        }
    }
    
    // MARK: - 페이지네이션
    private var pageNavigation: some View {
        HStack(spacing: FoodSearchConstants.pageNavigationHSpacing) {
            Button(action: { viewModel.goToPreviousPage() }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(viewModel.currentPage == 1 ? Color.grey02 : Color.grey05)
            }
            .disabled(viewModel.currentPage == 1)
            
            Button(action: { viewModel.goToNextPage() }) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(viewModel.currentPage >= viewModel.totalPages ? Color.grey02 : Color.grey05)
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
    
    // MARK: - 저장하기 버튼 액션
    private func saveAction() {
        Task {
            do {
                try await viewModel.saveSelected(date: selectedDate, mealType: mealType, token: token)
                dismiss()
            } catch {
                print("저장 실패:", error.localizedDescription)
            }
        }
    }
}

// #Preview {
//     StatefulPreviewWrapper([MealPlanRoute]()) { path in
//         FoodSearchView(path: path)
//  }
// }
