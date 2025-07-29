//
//  WeightPopupView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/29/25.
//
import SwiftUI

struct WeightPopupView: View {
    @Binding var weightText: String
    var onCancel: () -> Void
    var onSave: (Double) -> Void

    @FocusState private var isFocused: Bool

    var isValid: Bool {
        if let value = Double(weightText), weightText.count <= 4 {
            return value > 0
        }
        return false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 타이틀
            Text("몸무게 기록")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.grey06)
                .frame(height: 24)
                .padding(.top, 20)
                .padding(.horizontal, 20)

            // 선
            Rectangle()
                .fill(Color.grey01)
                .frame(width: 300, height: 1)
                .padding(.top, 15)
                .padding(.leading, 20)

            // 입력박스
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? Color.orange05 : Color.grey01, lineWidth: 1)
                    .frame(width: 300, height: 54)

                HStack {
                    TextField("", text: $weightText)
                        .focused($isFocused)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 18))
                        .foregroundColor(.grey05)
                        .padding(.leading, 20)
                        .padding(.vertical, 15)

                    Spacer()

                    Text("kg")
                        .font(.system(size: 18))
                        .foregroundColor(.grey03)
                        .padding(.trailing, 20)
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)

            // 버튼들
            HStack(spacing: 10) {
                // 취소
                Button(action: onCancel) {
                    Text("취소")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 145, height: 50)
                        .background(Color.grey01)
                        .foregroundColor(.grey05)
                        .cornerRadius(5)
                }

                // 저장
                Button(action: {
                    if let value = Double(weightText), isValid {
                        onSave(value)
                    }
                }) {
                    Text("저장")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 145, height: 50)
                        .background(isValid ? Color.orange05 : Color.orange01)
                        .foregroundColor(isValid ? .grey00 : .orange03)
                        .cornerRadius(5)
                }
                .disabled(!isValid)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
        .frame(width: 340, height: 243)
        .background(Color.grey00)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
    }
}

