//
//  ManualAddMealView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/26/25.
//

import SwiftUI

struct ManualAddMealView: View {
    // MARK: - Property
    @Environment(\.dismiss) var dismiss   // 뒤로가기
    
    /// 어디에 추가할지
    let selectedDate: Date
    let mealType: MealType
    var token: String? = nil

    /// 서비스 주입
    private let service: FoodServiceType = FoodService()

    /// 입력 받는 정보 정의
    @State private var foodName: String = ""
    @State private var foodCalories: String = ""
    @State private var foodCarb: String = ""
    @State private var foodProtein: String = ""
    @State private var foodFat: String = ""
    
    /// Double로 변환된 값
    private var caloriesValue: Double? {
        Double(foodCalories)
    }

    private var carbValue: Double? {
        Double(foodCarb)
    }

    private var proteinValue: Double? {
        Double(foodProtein)
    }

    private var fatValue: Double? {
        Double(foodFat)
    }
    
    fileprivate enum ManualAddMealConstants {
        static let baseWidth: CGFloat = 340  // 기본적으로 전부 적용되는 너비
        static let VSpacing: CGFloat = 25
        static let HSpacing: CGFloat = 20
        static let textFieldTopPadding: CGFloat = 25
        static let textFieldBottomPadding: CGFloat = 170
        static let noticeHeight: CGFloat = 60 // notice 이미지 높이
    }
    
    /// mainButton 활성화 조건 ('식단명' + '칼로리')
    private var isFormValid: Bool {
        !foodName.isEmpty && caloriesValue != nil
    }
    /// '추가하기' 버튼 색상
    private var addButtonColor: Color {
        isFormValid ? .grey05 : .grey01
    }
    /// '추가하기' 버튼 텍스트 색상
    private var addButtonTextColor: Color {
        isFormValid ? .grey00 : .grey02
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            topTitle
                .background(Color.grey00)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
                .zIndex(1)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: ManualAddMealConstants.VSpacing) {
                    /// 텍스트 입력란 부분
                    VStack(spacing: ManualAddMealConstants.VSpacing) {
                        /// '식단명'
                        foodNameInput
                        
                        /// '칼로리' + '탄수화물'
                        HStack(spacing: ManualAddMealConstants.HSpacing) {
                            foodCaloriesInput
                            
                            foodCarbInput
                        }
                        
                        /// '단백질' + '지방'
                        HStack(spacing: ManualAddMealConstants.HSpacing) {
                            foodProteinInput
                            
                            foodFatInput
                        }
                    }
                    .padding(.top, ManualAddMealConstants.textFieldTopPadding)
                    .padding(.bottom, ManualAddMealConstants.textFieldBottomPadding)
                    .frame(width: ManualAddMealConstants.baseWidth)
                    
                    /// 노티스
                    notice
                    
                    /// '추가하기' 버튼
                    SubButton(
                        color: addButtonColor,
                        text: "추가하기",
                        textColor: addButtonTextColor
                    ) {
                        guard isFormValid else { return }
                            Task {
                                do {
                                    try await service.addCustomUserMeal(
                                        name: foodName,
                                        calorie: caloriesValue ?? 0,
                                        carb: carbValue ?? 0,
                                        protein: proteinValue ?? 0,
                                        fat: fatValue ?? 0,
                                        date: selectedDate,
                                        mealTime: mealType,
                                        token: token
                                    )
                                    NotificationCenter.default.post(name: .userMealsDidChange, object: nil)
                                    dismiss()
                            } catch {
                                print("직접 추가 실패:", error.localizedDescription)
                            }
                        }
                    }
                    .disabled(!isFormValid)
                    .frame(width: ManualAddMealConstants.baseWidth)
                }
                
            }
        }
        .background(Color.background)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - 상단 제목
    private var topTitle: some View {
        NavigationBar(title: "직접 추가") {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
            }
        }
    }
    
    // MARK: - '식단명' 입력란
    private var foodNameInput: some View {
        InputFieldView(title: {
            Text("식단명")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
            + Text(" *")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.orange05)
        }, placeholder: "식단명을 입력하세요.", text: $foodName)
    }
    
    // MARK: - '칼로리' 입력란
    private var foodCaloriesInput: some View {
        InputFieldView(title: {
            Text("칼로리")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
            + Text(" *")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.orange05)
        }, placeholder: "", text: $foodCalories, keyboardType: .numberPad, suffixText: "kcal")
    }
    
    // MARK: - '탄수화물' 입력란
    private var foodCarbInput: some View {
        InputFieldView(title: {
            Text("탄수화물")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
        }, placeholder: "", text: $foodCarb, keyboardType: .numberPad, suffixText: "g")
    }
    
    // MARK: - '단백질' 입력란
    private var foodProteinInput: some View {
        InputFieldView(title: {
            Text("단백질")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
        }, placeholder: "", text: $foodProtein, keyboardType: .numberPad, suffixText: "g")
    }
    
    // MARK: - '지방' 입력란
    private var foodFatInput: some View {
        InputFieldView(title: {
            Text("지방")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
        }, placeholder: "", text: $foodFat, keyboardType: .numberPad, suffixText: "g")
    }
    
    // MARK: - Notice
    private var notice: some View {
        Image("addMealNotice")
            .resizable()
            .frame(width: ManualAddMealConstants.baseWidth, height: ManualAddMealConstants.noticeHeight)
    }
}

// #Preview {
//     ManualAddMealView()
// }

