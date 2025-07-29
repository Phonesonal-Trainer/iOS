//
//  MealInfoView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/27/25.
//

import SwiftUI

struct MealInfoPopup: View {
    // MARK: - Property
    @ObservedObject var viewModel: MealInfoViewModel
    @Environment(\.dismiss) private var dismiss   // 뒤로가기
    @State private var showEdit = false   // 수정 팝업창 띄우기
    
    // MARK: - 상수 정의
    fileprivate enum MealInfoConstants {
        static let width: CGFloat = 340  // 배경 너비
        static let height: CGFloat = 417  // 배경 높이
        static let baseWidth: CGFloat = 300
        static let VSpacing: CGFloat = 30
        static let titleDividerSpacing: CGFloat = 15  // 타이틀이랑 divider 사이 간격
        static let middleInfoContentSpacing: CGFloat = 15  // 중간 vstack 두개 사이의 간격
        static let mealInfoVSpacing: CGFloat = 10   // mealInfo 섹션에서의 세로 간격
        static let nameAndFavoriteSpacing: CGFloat = 8 // 식단 이름이랑 별 사이 간격
        static let favoriteButtonSize: CGFloat = 20  // 별 사이즈
        static let buttonWidth: CGFloat = 145
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: MealInfoConstants.VSpacing) {
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
                .frame(width: MealInfoConstants.width, height: MealInfoConstants.height)
        )
    }
    
    // MARK: - 타이틀 + divider
    private var titleAndDivider: some View {
        VStack(spacing: MealInfoConstants.titleDividerSpacing) {
            /// 타이틀
            Text("식단 정보")
                .font(.PretendardMedium20)
                .foregroundStyle(Color.grey06)
            
            Divider()
                .frame(width: MealInfoConstants.baseWidth)
        }
    }
    
    // MARK: - 중간 음식 정보
    private var middleInfoContent: some View {
        VStack(spacing: MealInfoConstants.middleInfoContentSpacing) {
            /// 식단 이름 + 양
            mealInfo
            /// 탄단지 정보
            VStack(spacing: MealInfoConstants.mealInfoVSpacing) {
                NutrientRow(percentage: calcRatio(viewModel.nutrient.carb), label: "탄수화물", percentText: calcPercent(viewModel.nutrient.carb), gram: viewModel.nutrient.carb)
                NutrientRow(percentage: calcRatio(viewModel.nutrient.protein), label: "단백질", percentText: calcPercent(viewModel.nutrient.protein), gram: viewModel.nutrient.protein)
                NutrientRow(percentage: calcRatio(viewModel.nutrient.fat), label: "지방", percentText: calcPercent(viewModel.nutrient.fat), gram: viewModel.nutrient.fat)
            }
        }
    }
    
    // MARK: - 식단 이름 + 양
    private var mealInfo: some View {
        VStack(spacing: MealInfoConstants.mealInfoVSpacing) {
            /// 식단 이름 + 즐겨찾기 버튼
            HStack(spacing: MealInfoConstants.nameAndFavoriteSpacing) {
                Text(viewModel.meal.name)
                    .font(.PretendardSemiBold22)
                    .foregroundStyle(Color.grey06)
                
                Button(action: {
                    viewModel.toggleFavorite()
                    // 즐겨찾기 저장 로직
                }) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(viewModel.isFavorite ? Color.yellow02 : .grey02)
                        .frame(width: MealInfoConstants.favoriteButtonSize, height: MealInfoConstants.favoriteButtonSize)
                }
                .buttonStyle(.plain)
            }
            /// 식단 양 + 칼로리
            Text("\(viewModel.meal.amount)g (\(viewModel.meal.kcal)kcal)")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey03)
        }
    }
    
    // MARK: - '수정' + '확인' 버튼
    private var buttons: some View {
        HStack {
            NavigationLink(destination: EditMealPopup(viewModel: viewModel)) {
                SubButton(color: .grey01, text: "수정", textColor: .grey05) {
                    // 수정 화면으로 넘어가기
                    showEdit = true
                }
                .frame(width: MealInfoConstants.buttonWidth)
            }
            
            SubButton(color: .orange05, text: "확인", textColor: .grey00) {
                dismiss()
            }
            .frame(width: MealInfoConstants.buttonWidth)
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
