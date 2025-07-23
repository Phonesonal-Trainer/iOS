//
//  InputFieldView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//

import SwiftUI

struct InputFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var suffixText: String? = nil // <- ✅ "세"와 같은 고정 텍스트 지원

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.PretendardMedium18)
                .foregroundColor(.grey06)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.PretendardRegular18)
                        .foregroundColor(.grey02)
                        .padding(.leading, 12)
                }

                HStack {
                    TextField("", text: $text)
                        .keyboardType(keyboardType)
                        .font(.PretendardRegular18)
                        .foregroundColor(.grey05)
                        .padding(.leading, 12)
                        .padding(.vertical, 12)

                    // ✅ 항상 보이는 오른쪽 텍스트
                    if let suffix = suffixText {
                        Text(suffix)
                            .font(.PretendardRegular18)
                            .foregroundColor(.grey03)
                            .padding(.trailing, 12)
                    }
                }
            }
            .frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.line, lineWidth: 1)
            )
        }
    }
}
