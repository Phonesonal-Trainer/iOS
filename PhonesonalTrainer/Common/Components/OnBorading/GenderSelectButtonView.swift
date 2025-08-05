//
//  GenderSelectButtonView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//

import SwiftUI

// 성별을 나타내는 열거형
enum Gender: String, CaseIterable {
    case male = "남성"
    case female = "여성"
}

struct GenderSelectButtonView: View {
    let gender: Gender
    @Binding var selectedGender: Gender?

    var isSelected: Bool {
        selectedGender == gender
    }

    var body: some View {
        Button(action: {
            selectedGender = gender
        }) {
            Text(gender.rawValue)
                .font(.PretendardMedium18)
                .foregroundColor(isSelected ? .orange05 : .grey02)
                .frame(width: 75, height: 52) // ✅ 버튼 전체 사이즈 고정
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(isSelected ? Color.orange05 : Color.grey02, lineWidth: 1)
                )
        }
    }
}

