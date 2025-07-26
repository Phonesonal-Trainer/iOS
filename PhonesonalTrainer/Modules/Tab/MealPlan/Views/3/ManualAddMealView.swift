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
    
    // MARK: - 정의
    /// 입력 받는 정보 정의
    @State private var foodName: String = ""
    @State private var foodCalories: String = ""   // 근데 얘네들 int로 받아야되는거 아닌가
    @State private var foodCarb: String = ""
    @State private var foodProtein: String = ""
    @State private var foodFat: String = ""
    
    fileprivate enum ManualAddMealConstants {
        static let baseWidth: CGFloat = 340  // 기본적으로 전부 적용되는 너비
        static let VSpacing: CGFloat = 25
        static let HSpacing: CGFloat = 20
        static let textFieldTopPadding: CGFloat = 25
        static let textFieldBottomPadding: CGFloat = 100
        static let noticeHeight: CGFloat = 60 // notice 이미지 높이
    }
    /// mainButton 활성화 조건 ('식단명' + '칼로리')
    private var isFormValid: Bool {
        !foodName.isEmpty && !foodCalories.isEmpty
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
            
            ScrollView {
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
                        if isFormValid {
                            // 입력한 음식 정보 저장
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

#Preview {
    ManualAddMealView()
}

