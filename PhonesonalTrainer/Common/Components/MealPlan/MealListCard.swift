//
//  MealListItemView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/20/25.
//

import SwiftUI

struct MealListCard: View {
    let item: MealModel
    
    // MARK: - Constants(상수 정의)
    fileprivate enum MealCardConstants {
        static let imageSize: CGFloat = 45
        static let imageTextSpacing: CGFloat = 15   // 이미지와 텍스트 간 간격
        static let textLineSpacing: CGFloat = 2     // name과 amount 사이 간격
        static let mealItemTopPadding: CGFloat = 10
        static let mealItemBottomPadding: CGFloat = 10
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: MealCardConstants.imageTextSpacing, content: {
            // 좌측 식단 이미지
            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: MealCardConstants.imageSize, height: MealCardConstants.imageSize)
            }
            // 우측 텍스트 정보
            rightInfo
        })
    }
    
    /// 우측 텍스트 (HStack ( VStack ( 이름 + 그램 ) + 칼로리 )) 정보
    private var rightInfo: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: MealCardConstants.textLineSpacing, content: {
                mealName
                mealAmount
            })
            
            Spacer()
            
            mealKcal
        }
        .padding(.top, MealCardConstants.mealItemTopPadding)
        .padding(.bottom, MealCardConstants.mealItemBottomPadding)
    }
    
    /// 식단 이름 표시
    private var mealName: some View {
        Text(item.name)
            .font(.PretendardSemiBold18)
            .foregroundStyle(.grey05)
    }
    
    /// 식단 그램 표시
    private var mealAmount: some View {
        Text(item.amount)
            .font(.PretendardMedium14)
            .foregroundStyle(.grey02)
    }
    
    /// 식단 칼로리 표시
    private var mealKcal: some View {
        Text(item.kcal)
            .font(.PretendardMedium18)
            .foregroundStyle(.orange04)
    }
}

#Preview {
    MealListCard(item: MealModel(name: "소고기", amount: "180g", kcal: "321 kcal", imageName: "temp_image"))
}
