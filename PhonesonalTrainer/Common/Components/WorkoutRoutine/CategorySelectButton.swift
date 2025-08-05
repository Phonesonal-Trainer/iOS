//
//  CategorySelectButton.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/2/25.
//

import SwiftUI

struct CategorySelectButton: View {
    let category: WorkoutType
    @Binding var selectedCategory: WorkoutType?
    
    var isSelected: Bool {
        selectedCategory == category
    }
    
    // MARK: - 상수 정의
    fileprivate enum CategoryConstants {
        static let width: CGFloat = 75
        static let height: CGFloat = 52
    }
    
    var body: some View {
        Button(action: {
            selectedCategory = category
        }) {
            Text(category.rawValue)
                .font(.PretendardMedium18)
                .foregroundStyle(isSelected ? Color.orange05 : Color.grey02)
                .frame(width: CategoryConstants.width, height: CategoryConstants.height)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(isSelected ? Color.orange05 : Color.grey02, lineWidth: 1)
                )
        }
    }
}


