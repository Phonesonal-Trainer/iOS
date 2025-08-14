//
//  EditHeight.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/14/25.
//

//  EditHeightView.swift
//  PhonesonalTrainer
//
//  신장 수정 (100–250cm 사이 정수만)

import SwiftUI

struct EditHeightView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool

    let originalHeight: Int
    var onSave: (Int) -> Void

    @State private var heightText: String
    @State private var shakeOffset: CGFloat = 0

    private let minHeight = 100
    private let maxHeight = 250

    init(originalHeight: Int, onSave: @escaping (Int) -> Void) {
        self.originalHeight = originalHeight
        self.onSave = onSave
        _heightText = State(initialValue: "\(originalHeight)")
    }

    // MARK: - Computed
    private var trimmed: String { heightText.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var currentValue: Int? { Int(trimmed) }
    private var withinRange: Bool {
        if let v = currentValue { return (minHeight...maxHeight).contains(v) } else { return false }
    }
    private var changed: Bool { currentValue != nil && currentValue! != originalHeight }
    private var canSave: Bool { withinRange && changed }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            // 본문
            VStack(alignment: .leading, spacing: 12) {
                Text("신장")
                    .font(.system(size: 14))
                    .foregroundStyle(.grey05)

                // 입력 박스
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.orange05 : Color.grey01, lineWidth: 1)
                        .frame(height: 54)

                    HStack {
                        TextField("", text: $heightText)
                            .focused($isFocused)
                            .keyboardType(.numberPad)
                            .font(.system(size: 16))
                            .foregroundStyle(.grey05)
                            .padding(.leading, 16)
                            .padding(.vertical, 15)
                            .offset(x: shakeOffset)
                            .onChange(of: heightText) { _, new in
                                // 숫자만 허용 + 최대 3자리
                                let filtered = new.filter { $0.isNumber }
                                let cut = String(filtered.prefix(3))
                                if cut != new { heightText = cut }
                            }

                        if !heightText.isEmpty {
                            Button {
                                heightText = ""
                                isFocused = true
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.grey03)
                            }
                            .padding(.trailing, 12)
                            .accessibilityLabel("입력 지우기")
                        }

                        Text("cm")
                            .font(.system(size: 16))
                            .foregroundStyle(.grey03)
                            .padding(.trailing, 16)
                    }
                }
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
                    if canSave, let v = currentValue {
                        onSave(v)
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
                        .animation(.easeInOut(duration: 0.15), value: canSave)
                }
                .disabled(!canSave)
                .padding(.horizontal, 25)
                .padding(.vertical, 8)
                .background(Color.grey00.opacity(0.95))
            }
        }
        .toolbar(.hidden, for: .navigationBar)   // ← 여기 추가
                .navigationBarBackButtonHidden(true) 
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") { isFocused = false }
            }
        }
    }

    // MARK: - Top Bar (네 코드 기반, 타이틀만 교체)
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
            Text("신장 수정")
                .font(.PretendardMedium22)
                .foregroundStyle(.grey06)
        }
        .padding(.horizontal, 25)
        .frame(height: 56)
        .background(Color.grey00)
    }

    // MARK: - 흔들림 애니메이션 (WeightPopupView와 동일 톤)
    private func shakeTextField() {
        let xs: [CGFloat] = [-16, 16, -12, 12, -6, 6, 0]
        for (i, v) in xs.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * Double(i)) {
                withAnimation(.easeInOut(duration: 0.05)) {
                    shakeOffset = v
                }
            }
        }
    }
}

#Preview {
    // 프리뷰: 원래 165cm
    EditHeightView(originalHeight: 165) { _ in }
}
