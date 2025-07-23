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

    enum Field {
        case nickname
        case age
    }

    var isFormValid: Bool {
        !nickname.isEmpty && !age.isEmpty && selectedGender != nil
    }

    var body: some View {
        ZStack {
            Color.grey00.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // 수정된 BackHeaderView 적용 (타이틀 없음)
                        BackHeaderView {
                            // 뒤로가기 로직
                        }

                        // 페이지 인디케이터
                        HStack(spacing: 8) {
                            Capsule().fill(Color.orange04).frame(height: 3)
                            Capsule().fill(Color.grey01).frame(height: 3)
                            Capsule().fill(Color.grey01).frame(height: 3)
                            Capsule().fill(Color.grey01).frame(height: 3)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)

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
                        .padding(.horizontal)

                        // 닉네임 입력
                        InputFieldView(
                            title: "닉네임",
                            placeholder: "닉네임을 입력하세요.",
                            text: $nickname
                        )
                        .padding(.top, 16)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .nickname)

                        // 나이 + 성별
                        HStack(alignment: .top, spacing: 12) {
                            InputFieldView(
                                title: "나이",
                                placeholder: "",
                                text: $age,
                                keyboardType: .numberPad,
                                suffixText: "세"
                            )
                            .focused($focusedField, equals: .age)

                            VStack(alignment: .leading, spacing: 12) {
                                Text("성별")
                                    .font(.PretendardMedium18)
                                HStack(spacing: 8) {
                                    ForEach(Gender.allCases, id: \.self) { gender in
                                        GenderSelectButtonView(gender: gender, selectedGender: $selectedGender)
                                    }
                                }
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal)
                    }
                }

                // 하단 버튼
                MainButton(
                    color: isFormValid ? Color.grey05 : Color.grey01,
                    text: "다음",
                    textColor: isFormValid ? .white : .grey02
                ) {
                    if isFormValid {
                        // 다음 화면 이동
                    }
                }
                .disabled(!isFormValid)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .scrollDismissesKeyboard(.interactively) // iOS 15+ 자동 키보드 관리
        .onTapGesture { hideKeyboard() }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    OnboardingInfoInputView()
}
