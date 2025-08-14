//
//  EditName.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/14/25.
//


import SwiftUI

struct EditNameView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool

    let originalName: String
    var onSave: (String) -> Void

    @State private var name: String
    @State private var shakeOffset: CGFloat = 0

    private let maxLen = 7

    init(originalName: String, onSave: @escaping (String) -> Void) {
        self.originalName = originalName
        self.onSave = onSave
        _name = State(initialValue: originalName)
    }

    // MARK: - Computed
    private var trimmed: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var isEmpty: Bool { trimmed.isEmpty }
    private var withinLimit: Bool { !isEmpty && trimmed.count <= maxLen }
    private var changed: Bool { trimmed != originalName }
    private var canSave: Bool { withinLimit && changed }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            // 본문
            VStack(alignment: .leading, spacing: 12) {
                Text("닉네임")
                    .font(.system(size: 14))
                    .foregroundStyle(.grey05)

                // 입력 박스
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.orange05 : Color.grey01, lineWidth: 1)
                        .frame(height: 54)

                    HStack {
                        TextField("닉네임을 입력하세요.", text: $name)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .font(.system(size: 16))
                            .foregroundStyle(.grey05)
                            .padding(.leading, 16)
                            .padding(.vertical, 15)
                            .offset(x: shakeOffset)
                            .onChange(of: name) { _, new in
                                if new.count > maxLen { name = String(new.prefix(maxLen)) }
                            }

                        if !name.isEmpty {
                            Button {
                                name = ""
                                isFocused = true
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.grey03)
                            }
                            .padding(.trailing, 12)
                            .accessibilityLabel("입력 지우기")
                        }
                    }
                }

                Text("한글/영문 7자 이내")
                    .font(.system(size: 12))
                    .foregroundStyle(.grey04)
            }
            .padding(.horizontal, 25)
            .padding(.top, 12)

            Spacer()
        }
        .background(Color.grey00.ignoresSafeArea())
        // 하단 고정 CTA
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button {
                    if canSave {
                        onSave(trimmed)
                        dismiss()
                    } else {
                        shakeTextField()
                    }
                } label: {
                    Text("수정하기")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(canSave ? Color.orange05 : Color.orange01)
                        .foregroundStyle(canSave ? Color.grey00 : Color.orange03)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                }
                .disabled(!canSave)
                .padding(.horizontal, 25)
                .padding(.vertical, 8)
                .background(Color.grey00.opacity(0.95))
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Top Bar (너가 준 코드 기반, 타이틀만 변경)
    private var topBar: some View {
        ZStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.grey05)
                }
                Spacer()
            }
            Text("닉네임 수정") // ← "목표 수치" → "닉네임 수정"
                .font(.PretendardMedium22)
                .foregroundStyle(.grey06)
        }
        .padding(.horizontal, 25)
        .frame(height: 56)
        .background(Color.grey00)
    }

    // MARK: - 흔들림 (WeightPopupView와 동일 톤)
    private func shakeTextField() {
        let xs: [CGFloat] = [-16, 16, -12, 12, -6, 6, 0]
        for (i, v) in xs.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * Double(i)) {
                withAnimation(.easeInOut(duration: 0.05)) { shakeOffset = v }
            }
        }
    }
}

#Preview {
    // 프리뷰: 기존 닉네임 "서연이"
    EditNameView(originalName: "서연이") { _ in }
}
