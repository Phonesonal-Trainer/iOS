//
//  MealRecordSectionView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/21/25.
//

import SwiftUI

// MARK: - Constants(상수 정의)
fileprivate enum MealRecordConstants {
    static let titleHSpacing: CGFloat = 8   // '식단 기록' 과 '>' 사이
    static let arrowSize: CGFloat = 18   // 식단 기록 상세 가기 버튼('>') 사이즈
    
    static let recordSectionWidth: CGFloat = 340   // 박스 공통 너비
    static let emptyMealRecordHeight: CGFloat = 57    // 기록 없음 높이
    static let recordInfoHeight: CGFloat = 118     // 이미지 없는 기록 높이
}

struct MealRecordSectionView: View {
    @ObservedObject var viewModel: MealPlanViewModel
    @Binding var path: [MealPlanRoute]
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: MealRecordConstants.titleHSpacing, content: {
                Text("식단 기록")
                    .font(.PretendardMedium18)
                    .foregroundStyle(Color.grey06)
                
                Button(action: {
                    path.append(.mealRecord)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.grey05)
                        .frame(width: MealRecordConstants.arrowSize, height: MealRecordConstants.arrowSize)
                }
            })
            
            if viewModel.isLoading {
                ProgressView().frame(height: MealRecordConstants.recordInfoHeight)
            } else if let msg = viewModel.errorMessage {
                Text(msg).foregroundStyle(.red)
            } else {
                let type = viewModel.selectedType
                let state = viewModel.state(for: type)

                if state == .none {
                    EmptyMealRecordView()
                } else if let model = viewModel.item(for: type) {
                    // 이미지 유무는 카드 내부에서 판단
                    NutrientInfoCard(Nutrient: model, showsImage: true)
                } else {
                    EmptyMealRecordView()
                }
            }
        }
        .padding(.horizontal)
        // 날짜가 바뀌면 API 재호출
        .task(id: viewModel.selectedDate) {
            await viewModel.load()
        }
        // 첫 진입 시 한 번 로드 (필요 시)
        .task {
            if viewModel.items.isEmpty {
                await viewModel.load()
            }
        }
    }
}


/// 기록 X
struct EmptyMealRecordView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color(.grey01))
            .frame(width: MealRecordConstants.recordSectionWidth, height: MealRecordConstants.emptyMealRecordHeight)
            .overlay(
                Text("아직 기록 전이에요.")
                    .font(.PretendardRegular14)
                    .foregroundStyle(Color(.grey03))
            )
    }
}


