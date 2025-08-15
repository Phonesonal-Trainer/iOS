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
    let selectedDate: Date 
    @State private var uploadedImage: UIImage? = nil  // 이미지 업로드
    @StateObject private var viewModel = AddedMealViewModel()
    @Environment(\.dismiss) private var dismiss // 뒤로가기 액션
    @Binding var path: [MealPlanRoute]
    
    @State private var selectedMealViewModel: MealInfoViewModel? = nil
    @State private var showPopup: Bool = false  // 식단 정보 팝업
    @State private var showEditPopup: Bool = false  // 식단 정보 수정 팝업
    @State private var showDeletePopup: Bool = false   // 식단 삭제 재확인 팝업
    @State private var pendingDelete: MealRecordEntry? = nil
    
    private let foodService: FoodServiceType = FoodService()
    @ObservedObject var favoritesStore: FavoritesStore
    
    // MARK: - 상수 정의
    fileprivate enum MealRecordDetailConstant {
        static let basicWidth: CGFloat = 340
        static let vSpacing: CGFloat = 25
    }
    
    // MARK: - Body
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                // 상단 NavigationBar
                NavigationBar(title: "\(mealType.segmentTitle) 식단 기록") {
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: MealRecordDetailConstant.vSpacing) {
                        // 이미지 업로드 (서버에 업로드) -> 공용 컴포넌트 고려
                        ImageUploadButton(image: $uploadedImage, isLocal: false)
                            .padding(.top, MealRecordDetailConstant.vSpacing)
                        
                        RecordInfoView()
                        
                        if mealType != .snack {
                            MealCheckListView(selectedDate: .constant(selectedDate), mealType: mealType)
                        }
                        
                        
                        AddedMealSectionView(
                            viewModel: viewModel,
                            path: $path,
                            selectedMealViewModel: $selectedMealViewModel, // 바인딩으로 전달
                            showPopup: $showPopup,
                            showDeletePopup: $showDeletePopup,
                            selectedDate: .constant(selectedDate),  // 상세화면은 날짜 고정 → 상수 바인딩
                            mealType: mealType,
                            pendingDelete: $pendingDelete
                        )
                    }
                    .padding(.horizontal)
                }
                .background(Color.background)
            }
            .navigationBarBackButtonHidden(true) // 기본 NavigationBackButton 숨김
            
            if let viewModel = selectedMealViewModel, showPopup {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    
                MealInfoPopup(viewModel: viewModel, isPresented: $showPopup, showEditPopup: $showEditPopup, foodService: foodService, favoritesStore: favoritesStore)
                    .transition(.scale)
                    .zIndex(2)
            }
            
            if showEditPopup, let vm = selectedMealViewModel {
                EditMealPopup(viewModel: vm, userMealsVM: viewModel, isPresented: $showEditPopup, foodService: foodService, favoritesStore: favoritesStore)
                    .zIndex(3)
            }
            
            if showDeletePopup, let entry = pendingDelete {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                MealDeletePopup(
                    viewModel: viewModel,
                    isPresented: $showDeletePopup,
                    entry: entry,                               // 대상 전달
                    onFinish: { pendingDelete = nil }           // 닫힐 때 클리어
                )
                .transition(.scale)
                .zIndex(2)
            }
        }
    }
}

// #Preview {
//     StatefulPreviewWrapper([MealPlanRoute]()){ path in
//         MealRecordDetailView(mealType: .breakfast, selectedDate: 2025-08-12, path: path)
//     }
// }
