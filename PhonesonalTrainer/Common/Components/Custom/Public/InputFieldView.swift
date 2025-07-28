//
//  InputFieldView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//

import SwiftUI

struct InputFieldView<TitleView: View>: View {
    let titleView: TitleView
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var suffixText: String? = nil

    @FocusState private var isFocused: Bool  // 포커스 상태 관리

    init(
        @ViewBuilder title: () -> TitleView,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        suffixText: String? = nil
    ) {
        self.titleView = title()
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.suffixText = suffixText
    }

    var borderColor: Color {
        isFocused ? .orange05 : .line
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            titleView

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
                        .focused($isFocused)  // 포커스 바인딩

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
                    .stroke(borderColor, lineWidth: 1)
            )
        }
    }
}
