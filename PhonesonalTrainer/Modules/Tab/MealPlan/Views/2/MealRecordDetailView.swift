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
    @State private var uploadedImage: UIImage? = nil  // 이미지 업로드
    @StateObject private var viewModel = AddedMealViewModel()
    @Environment(\.dismiss) private var dismiss // 뒤로가기 액션
    @Binding var path: [MealPlanRoute]
    
    @State private var selectedMealViewModel: MealInfoViewModel? = nil
    @State private var showPopup: Bool = false  // 식단 정보 팝업
    @State private var showEditPopup: Bool = false  // 식단 정보 수정 팝업
    
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
                        ImageUploadButton(image: $uploadedImage, isLocal: false)
                            .padding(.top, MealRecordDetailConstant.vSpacing)
                        
                        RecordInfoView()
                        
                        MealCheckListView()
                        // 추가 식단 영역 필요 시 추가
                        
                        AddedMealSectionView(
                            viewModel: viewModel,
                            path: $path,
                            selectedMealViewModel: $selectedMealViewModel, // 바인딩으로 전달
                            showPopup: $showPopup)
                    }
                    .padding(.horizontal)
                }
                .background(Color.background)
            }
            .navigationBarBackButtonHidden(true) // 기본 NavigationBackButton 숨김
            
            if let viewModel = selectedMealViewModel, showPopup {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    
                MealInfoPopup(viewModel: viewModel, isPresented: $showPopup, showEditPopup: $showEditPopup)
                    .transition(.scale)
                    .zIndex(2)
            }
            
            if showEditPopup, let vm = selectedMealViewModel {
                EditMealPopup(viewModel: vm, isPresented: $showEditPopup)
                    .zIndex(3)
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper([MealPlanRoute]()){ path in
        MealRecordDetailView(mealType: .breakfast, path: path)
    }
}
