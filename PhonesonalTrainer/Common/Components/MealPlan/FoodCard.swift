//
//  FoodCard.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/25/25.
//

import SwiftUI

struct FoodCard: View {
    // MARK: - Property
    let item: MealModel
    
    @ObservedObject var viewModel: FoodSearchViewModel
    
    // MARK: - 상수 정의
    fileprivate enum FoodCardConstants {
        static let imageTextSpacing: CGFloat = 8
        static let textLineSpacing: CGFloat = 5
        static let hSpacing: CGFloat = 5
        static let imageSize: CGFloat = 16
        static let checkboxSize: CGFloat = 20
        static let edgePadding: CGFloat = 15
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: FoodCardConstants.hSpacing) {
            VStack(spacing: FoodCardConstants.textLineSpacing) {
                topTitleText
                
                subTitleText
            }
            Button(action: {
                viewModel.toggleSelection(of: item)
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundStyle(viewModel.selectedMealIDs.contains(item.id) ? Color.orange05 : Color.grey02)
                    .frame(width: FoodCardConstants.checkboxSize, height: FoodCardConstants.checkboxSize)
            }
        }
        .padding(FoodCardConstants.edgePadding)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(viewModel.selectedMealIDs.contains(item.id) ? Color.orange01 : Color.grey01)
                .stroke(viewModel.selectedMealIDs.contains(item.id) ? Color.orange03 : Color.clear, lineWidth: 1)
        )
            
    }
    
    // MARK: - 상단 타이틀 (이미지 + 이름)
    private var topTitleText: some View {
        HStack(spacing: FoodCardConstants.imageTextSpacing) {
            AsyncImage(url: URL(string: item.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)   // fit? fill?
                    .frame(width: FoodCardConstants.imageSize, height: FoodCardConstants.imageSize)
            } placeholder: {
                ProgressView()
                    .frame(width: FoodCardConstants.imageSize, height: FoodCardConstants.imageSize)
            }
            
            Text(item.name)  // 선택에 따라 텍스트 색상 달라짐.
                .font(.PretendardSemiBold16)
                .foregroundStyle(viewModel.selectedMealIDs.contains(item.id) ? Color.orange05 : Color.grey05)
        }
    }
    
    // MARK: - 서브 설명 (양 + 칼로리)
    private var subTitleText: some View {
        Text("1인분 (\(item.amount)g) / \(item.kcal)kcal")
            .font(.PretendardRegular12)
            .foregroundStyle(Color.grey03)
    }
}

