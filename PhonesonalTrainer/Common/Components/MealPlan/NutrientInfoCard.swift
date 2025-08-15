//
//  NutrientInfoCard.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/22/25.
//

import SwiftUI

struct NutrientInfoCard: View {
    let Nutrient: NutrientInfoModel
    @StateObject private var viewModel = MealPlanViewModel()
    
    // MARK: - 상수 정의
    fileprivate enum NutrientInfoConstants {
        static let vSpacing: CGFloat = 15
        static let textHSpacing: CGFloat = 10
        static let textVSpacing: CGFloat = 5
        static let textHPadding: CGFloat = 25
        static let imageWidth: CGFloat = 280
        static let imageHeight: CGFloat = 160
        static let cardWidth: CGFloat = 340
        static let cardHeight: CGFloat = 118 // 이미지 없는 기록 높이
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // 카드 배경 (이미지가 있어도/없어도 동일한 컨테이너)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(.grey00))
                .frame(width: NutrientInfoConstants.cardWidth,
                       height: NutrientInfoConstants.cardHeight + extraHeightForImage)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
            
            // 실제 콘텐츠
            VStack(spacing: NutrientInfoConstants.vSpacing) {
                mealTypeAndKcalText
                
                // 이미지: WITH_IMAGE + 유효한 URL일 때만
                if shouldShowImage, let urlStr = Nutrient.imageUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Rectangle().fill(Color(.grey01))
                                ProgressView()
                            }
                        case .success(let img):
                            img
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            ZStack {
                                Rectangle().fill(Color(.grey01))
                                Image(systemName: "photo")
                                    .foregroundStyle(.grey03)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: NutrientInfoConstants.imageWidth,
                            height: NutrientInfoConstants.imageHeight)
                     .clipped()
                     .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                // 하단: 탄단지 항목
                HStack {
                    carbProteinFat(title: "탄수화물", value: formatToString(Nutrient.carb))
                        .padding(.trailing, NutrientInfoConstants.textHPadding)
                    divider()
                    carbProteinFat(title: "단백질", value: formatToString(Nutrient.protein))
                        .padding(.leading, NutrientInfoConstants.textHPadding)
                        .padding(.trailing, NutrientInfoConstants.textHPadding)
                    divider()
                    carbProteinFat(title: "지방", value: formatToString(Nutrient.fat))
                        .padding(.leading, NutrientInfoConstants.textHPadding)
                }
            }
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Helpers
    private var shouldShowImage: Bool {
        Nutrient.status == .withImage && (Nutrient.imageUrl?.isEmpty == false)
    }

    // 카드 높이를 이미지 유무에 따라 늘리기
    private var extraHeightForImage: CGFloat {
        shouldShowImage ? NutrientInfoConstants.imageHeight : 0
    }
    
    // MARK: - 식사 타입과 섭취 칼로리 텍스트 뷰
    private var mealTypeAndKcalText: some View {
        HStack(spacing: NutrientInfoConstants.textHSpacing, content: {
            Text("\(Nutrient.mealType ?? "") 섭취 칼로리")
                .font(.PretendardMedium16)
                .foregroundStyle(Color.grey05)
            Text("\(formatKcal(Nutrient.kcal))kcal")
                .font(.PretendardSemiBold16)
                .foregroundStyle(Color.orange05)
        })
    }
    
    // MARK: - 탄단지 항목 뷰
    private func carbProteinFat(title: String, value: String) -> some View {
        VStack(spacing: NutrientInfoConstants.textVSpacing, content: {
            Text(title)
                .font(.PretendardRegular14)
                .foregroundStyle(Color.grey03)
            Text("\(value)g")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey05)
        })
        
    }
    
    // MARK: - 세로선
    private func divider() -> some View {
        Rectangle()
            .fill(Color.line)
            .frame(width: 1, height: 30)
    }
}

