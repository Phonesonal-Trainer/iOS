//
//  WorkoutSearchView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/2/25.
//

import SwiftUI

struct WorkoutSearchView: View {
    // MARK: - Property
    @StateObject private var viewModel = WorkoutSearchViewModel()
    @Environment(\.dismiss) private var dismiss // 뒤로가기
    @Binding var path: [WorkoutRoutineRoute]  // navigation 경로
    
    // MARK: - 상수 정의
    fileprivate enum WorkoutSearchConstants {
        static let baseWidth: CGFloat = 340  // 기본적으로 전부 적용되는 너비
        static let VSpacing: CGFloat = 25
        static let gridHeight: CGFloat = 346
        static let noResultSpacing: CGFloat = 15
        static let noticeHeight: CGFloat = 60 // notice 이미지 높이
        static let pageNavigationHSpacing: CGFloat = 10
        static let addWorkoutButtonWidth: CGFloat = 108
        static let addWorkoutButtonHeight: CGFloat = 28
    }
    
    /// '저장하기' 버튼 활성화 조건  ->  선택한 음식이 하나는 있어야 함.
    private var isValid: Bool {
        !viewModel.selectedExerciseIDs.isEmpty
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
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: WorkoutSearchConstants.VSpacing) {
                    // 서치바 + 운동 그리드
                    middleContent
                        .padding(.top, WorkoutSearchConstants.VSpacing)
                    
                    /// notice 이미지
                    notice
                    
                    // 저장 버튼
                    MainButton(
                        color: saveButtonColor,
                        text: "저장하기",
                        textColor: saveButtonTextColor
                    ) {
                        if isValid {
                            // 선택한 운동 정보 저장
                            dismiss()
                        }
                    }
                    .disabled(!isValid)
                    .frame(width: WorkoutSearchConstants.baseWidth)
                }
            }
        }
    }
    
    // MARK: - NavigationBar 상단
    private var topTitle: some View {
        NavigationBar(title: "운동 추가") {
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
    
    // MARK: - 중간 운동 검색 부분
    private var middleContent: some View {
        VStack(spacing: WorkoutSearchConstants.VSpacing) {
            /// 서치바
            CustomSearchBar(text: $viewModel.searchText, placeholder: "운동 검색")
            /// 운동 그리드 부분
            workoutGridView
            /// 페이지네이션
            pageNavigation
        }
    }
    
    // MARK: - 운동 아이템 그리드 뷰
    private var workoutGridView: some View {
        Group {
            if viewModel.pagedWorkouts.isEmpty {
                // 검색 결과 없음.
                VStack(spacing: WorkoutSearchConstants.noResultSpacing) {
                    Text("검색 결과가 없습니다.")
                        .font(.PretendardMedium16)
                        .foregroundStyle(Color.grey03)
                    
                    Button(action: {
                        path.append(.manualAdd)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.orange05)
                                .frame(width: WorkoutSearchConstants.addWorkoutButtonWidth, height: WorkoutSearchConstants.addWorkoutButtonHeight)
                            
                            Text("+ 직접 추가하기")
                                .font(.PretendardMedium12)
                                .foregroundStyle(Color.grey00)
                        }
                    }
                }
                .frame(width: WorkoutSearchConstants.baseWidth, height: WorkoutSearchConstants.gridHeight)
            } else {
                // 운동 그리드
                VStack {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.pagedWorkouts) { item in
                            WorkoutCard(item: item, viewModel: viewModel)
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .frame(height: WorkoutSearchConstants.gridHeight)
            }
        }
    }
    
    // MARK: - 페이지네이션
    private var pageNavigation: some View {
        HStack(spacing: WorkoutSearchConstants.pageNavigationHSpacing) {
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
        Image("workoutSearchNotice")
            .resizable()
            .frame(width: WorkoutSearchConstants.baseWidth, height: WorkoutSearchConstants.noticeHeight)
    }
}

#Preview {
    StatefulPreviewWrapper([WorkoutRoutineRoute]()) { path in
        WorkoutSearchView(path: path)
    }
}
