//
//  OnboardingInfoInputView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//

import SwiftUI
import Combine

struct OnboardingInfoInputView: View {
    @State private var nickname: String = ""
    @State private var age: String = ""
    @State private var selectedGender: Gender? = nil

    @FocusState private var focusedField: Field?
    @State private var keyboardHeight: CGFloat = 0

    enum Field {
        case nickname
        case age
    }

    var isFormValid: Bool {
        !nickname.isEmpty && !age.isEmpty && selectedGender != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // 뒤로가기 버튼
                Button(action: {
                    // 뒤로가기 로직
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.grey05)
                }
                .padding(.top, 8)

                // 페이지 인디케이터
                HStack(spacing: 8) {
                    Capsule().fill(Color.orange04).frame(width: 80, height: 3)
                    Capsule().fill(Color.grey01).frame(width: 80, height: 3)
                    Capsule().fill(Color.grey01).frame(width: 80, height: 3)
                    Capsule().fill(Color.grey01).frame(width: 80, height: 3)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                // 타이틀
                VStack(alignment: .leading, spacing: 6) {
                    Text("만나서 반가워요 👋")
                        .font(.PretendardSemiBold24)
                        .foregroundColor(.grey05)
                    Text("회원님의 정보를 입력해주세요.")
                        .font(.PretendardRegular20)
                        .foregroundColor(.grey03)
                }
                .padding(.top, 12)

                // 닉네임 입력
                InputFieldView(
                    title: "닉네임",
                    placeholder: "닉네임을 입력하세요.",
                    text: $nickname
                )
                .padding(.top, 16)
                .focused($focusedField, equals: .nickname)

                // 나이 + 성별
                HStack(alignment: .top, spacing: 24) {
                    // 나이 필드
                    InputFieldView(
                        title: "나이",
                        placeholder: "",
                        text: $age,
                        keyboardType: .numberPad,
                        suffixText: "세"
                    )
                    .focused($focusedField, equals: .age)
                    .frame(width: 160)
                    .padding(.top, 16)

                    // 성별 선택
                    VStack(alignment: .leading, spacing: 12) {
                        Text("성별")
                            .font(.PretendardMedium18)
                        HStack(spacing: 8) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                GenderSelectButtonView(gender: gender, selectedGender: $selectedGender)
                            }
                        }
                    }
                    .padding(.top, 16)
                }

                Spacer()

                // 다음 버튼
                Button(action: {
                    // 다음 화면 이동
                }) {
                    Text("다음")
                        .font(.PretendardSemiBold16)
                        .foregroundColor(isFormValid ? .grey0 : .grey02)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(isFormValid ? Color.grey05 : Color.grey01)
                        .cornerRadius(30)
                }
                .disabled(!isFormValid)
                .padding(.top, 256)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, keyboardHeight)
            .animation(.easeOut(duration: 0.3), value: keyboardHeight)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onReceive(Publishers.keyboardHeight) { height in
            self.keyboardHeight = height
        }
        .background(Color.white)
    }

    // 키보드 내리기
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    OnboardingInfoInputView()
}
