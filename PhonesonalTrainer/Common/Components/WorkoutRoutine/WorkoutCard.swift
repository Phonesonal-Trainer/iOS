//
//  WorkoutCard.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/2/25.
//

import SwiftUI

struct WorkoutCard: View {
    // MARK: - Property
    let item: SearchWorkoutModel
    
    @ObservedObject var viewModel: WorkoutSearchViewModel
    
    // MARK: - 상수 정의
    fileprivate enum WorkoutCardConstants {
        static let textLineSpacing: CGFloat = 5
        static let dotSize: CGFloat = 2  // 유형이랑 부위 사이에 있는 점
        static let textDotSpacing: CGFloat = 4
        static let checkboxSize: CGFloat = 20
        static let edgePadding: CGFloat = 15
        static let width: CGFloat = 165
        static let height: CGFloat = 70
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: WorkoutCardConstants.textLineSpacing) {
                topTitleText
                
                subTitleText
            }
            
            Spacer()
            
            Button(action: {
                viewModel.toggleSelection(item)
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundStyle(viewModel.isSelected(item) ? Color.orange05 : Color.grey02)
                    .frame(width: WorkoutCardConstants.checkboxSize, height: WorkoutCardConstants.checkboxSize)
            }
        }
        .padding(WorkoutCardConstants.edgePadding)
        .frame(width: WorkoutCardConstants.width, height: WorkoutCardConstants.height)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(viewModel.isSelected(item) ? Color.orange01 : Color.grey01)
                .stroke(viewModel.isSelected(item) ? Color.orange03 : Color.clear, lineWidth: 1)
        )
    }
    
    // MARK: - 운동 이름
    private var topTitleText: some View {
        Text(item.name)  // 선택에 따라 텍스트 색상 달라짐.
            .font(.PretendardSemiBold14)
            .foregroundStyle(viewModel.isSelected(item) ? Color.orange05 : Color.grey05)
    }
    
    // MARK: - 서브 설명 (유형 + 부위)
    private var subTitleText: some View {
        HStack(spacing: WorkoutCardConstants.textDotSpacing) {
            Text(item.category.rawValue)
                .font(.PretendardRegular12)
                .foregroundStyle(Color.grey03)
            
            Image(systemName: "circle")
                .resizable()
                .foregroundStyle(Color.grey02)
                .frame(width: WorkoutCardConstants.dotSize, height: WorkoutCardConstants.dotSize)
            
            Text(item.bodyPart.displayName)
                .font(.PretendardRegular12)
                .foregroundStyle(Color.grey03)
        }
    }
}


