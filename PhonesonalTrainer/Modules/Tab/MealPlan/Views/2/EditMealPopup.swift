//
//  EditMealPopup.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/28/25.
//

import SwiftUI

struct EditMealPopup: View {
    // MARK: - Property
    @ObservedObject var viewModel: MealInfoViewModel
    @State private var isFavorite: Bool = false  // 즐겨찾기 상태
    @Environment(\.dismiss) private var dismiss  // 뒤로가기
    
    // MARK: - 상수 정의
    fileprivate enum EditMealConstants {
        static let width: CGFloat = 340  // 배경 너비
        static let height: CGFloat = 417  // 배경 높이
        static let baseWidth: CGFloat = 300
        static let VSpacing: CGFloat = 30
        static let titleDividerSpacing: CGFloat = 15  // 타이틀이랑 divider 사이 간격
        static let middleInfoContentSpacing: CGFloat = 15  // 중간 vstack 두개 사이의 간격
        static let mealInfoVSpacing: CGFloat = 10   // mealInfo 섹션에서의 세로 간격
        static let nameAndFavoriteSpacing: CGFloat = 8 // 식단 이름이랑 별 사이 간격
        static let favoriteButtonSize: CGFloat = 20  // 별 사이즈
        static let editMealSectionHSpacing: CGFloat = 8  // -/+ 버튼과 텍스트 사이 간격
        static let editButtonSize: CGFloat = 18   // -/+ 버튼 사이즈
        static let buttonWidth: CGFloat = 145
    }
    
    /// '저장' 버튼 색상
    var saveButtonColor: Color {
        viewModel.hasChanges ? .orange05 : .orange01
    }
    
    /// '저장' 버튼 텍스트 색상
    var saveButtonTextColor: Color {
        viewModel.hasChanges ? .grey00 : .orange03
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: EditMealConstants.VSpacing) {
            /// 타이틀 + divider
            titleAndDivider
            
            /// 중간 음식 정보
            middleInfoContent
            
            /// '수정' + '확인' 버튼
            buttons
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grey00)
                .frame(width: EditMealConstants.width, height: EditMealConstants.height)
        )
    }
    
    // MARK: - 타이틀 + divider
    private var titleAndDivider: some View {
        VStack(spacing: EditMealConstants.titleDividerSpacing) {
            /// 타이틀
            Text("식단 정보")
                .font(.PretendardMedium20)
                .foregroundStyle(Color.grey06)
            
            Divider()
                .frame(width: EditMealConstants.baseWidth)
        }
    }
    
    // MARK: - 중간 음식 정보
    private var middleInfoContent: some View {
        VStack(spacing: EditMealConstants.middleInfoContentSpacing) {
            /// 식단 이름 + 양
            mealInfo
            /// 탄단지 정보
            VStack(spacing: EditMealConstants.mealInfoVSpacing) {
                NutrientRow(percentage: calcRatio(viewModel.nutrient.carb), label: "탄수화물", percentText: calcPercent(viewModel.nutrient.carb), gram: viewModel.nutrient.carb)
                NutrientRow(percentage: calcRatio(viewModel.nutrient.protein), label: "단백질", percentText: calcPercent(viewModel.nutrient.protein), gram: viewModel.nutrient.protein)
                NutrientRow(percentage: calcRatio(viewModel.nutrient.fat), label: "지방", percentText: calcPercent(viewModel.nutrient.fat), gram: viewModel.nutrient.fat)
            }
        }
    }
    
    // MARK: - 식단 이름 + 양
    private var mealInfo: some View {
        VStack(spacing: EditMealConstants.mealInfoVSpacing) {
            /// 식단 이름 + 즐겨찾기 버튼
            HStack(spacing: EditMealConstants.nameAndFavoriteSpacing) {
                Text(viewModel.meal.name)
                    .font(.PretendardSemiBold22)
                    .foregroundStyle(Color.grey06)
                
                Button(action: {
                    viewModel.toggleFavorite()
                    // 즐겨찾기 저장 로직
                }) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(viewModel.isFavorite ? Color.yellow02 : .grey02)
                        .frame(width: EditMealConstants.favoriteButtonSize, height: EditMealConstants.favoriteButtonSize)
                }
                .buttonStyle(.plain)
            }
            editMeal
        }
    }
    
    // MARK: - 식단 양 수정 섹션
    private var editMeal: some View {
        HStack(spacing: EditMealConstants.editMealSectionHSpacing) {
            /// '-' 버튼
            Button(action: {
                viewModel.updateAmount(by: -(viewModel.originalAmount / 2))
            }) {
                Image(systemName: "minus.circle")
                    .resizable()
                    .frame(width: EditMealConstants.editButtonSize, height: EditMealConstants.editButtonSize)
            }
            /// 식단 양 + 칼로리
            Text("\(viewModel.meal.amount)g (\(viewModel.meal.kcal)kcal)")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey03)
            /// '+' 버튼
            Button(action: {
                viewModel.updateAmount(by: viewModel.originalAmount / 2)
            }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: EditMealConstants.editButtonSize, height: EditMealConstants.editButtonSize)
            }
        }
    }
    
    // MARK: - '취소' + '확인' 버튼
    private var buttons: some View {
        HStack {
            SubButton(color: .grey01, text: "취소", textColor: .grey05) {
                // 뒤로가기
                dismiss()
            }
            .frame(width: EditMealConstants.buttonWidth)
            
            SubButton(color: saveButtonColor, text: "확인", textColor: saveButtonTextColor) {
                // 저장하기 원래 화면으로 돌아가는 로직
                dismiss()
            }
            .disabled(!viewModel.hasChanges)
            .frame(width: EditMealConstants.buttonWidth)
        }
    }
    
    // MARK: - 퍼센트 계산
    /// percentText를 위한 정수형
    func calcPercent(_ value: Int) -> Int {
        let total = viewModel.nutrient.carb + viewModel.nutrient.protein + viewModel.nutrient.fat
        guard total > 0 else { return 0 }
        return Int((Double(value) / Double(total)) * 100)
    }
    /// percentage를 위한 비율형
    func calcRatio(_ value: Int) -> Double {
        let total = viewModel.nutrient.carb + viewModel.nutrient.protein + viewModel.nutrient.fat
        guard total > 0 else { return 0.0 }
        return Double(value) / Double(total)
    }
}
