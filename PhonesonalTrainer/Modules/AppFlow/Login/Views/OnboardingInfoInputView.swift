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

    // 현재 페이지 index (예: 0 ~ 3)
    private let currentPage = 0
    private let totalPages = 4

    // 폼 유효성 검사
    var isFormValid: Bool {
        !nickname.isEmpty && !age.isEmpty && selectedGender != nil
    }

    // 버튼 색상
    var nextButtonColor: Color {
        isFormValid ? .grey05 : .grey01
    }

    // 버튼 텍스트 색상
    var nextButtonTextColor: Color {
        isFormValid ? .white : .grey02
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // (1) NavigationBar (스크롤 밖에서 고정)
                    NavigationBar {
                        Button(action: {
                            print("뒤로가기 버튼 클릭")
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.PretendardMedium22)
                                .foregroundColor(.grey05)
                        }
                    }

                    // (2) ScrollView
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            // 페이지 인디케이터
                            PageIndicator(
                                totalPages: totalPages,
                                currentPage: currentPage,
                                activeColor: .orange05,
                                inactiveColor: .grey01
                            )

                            // 타이틀
                            VStack(alignment: .leading, spacing: 6) {
                                Text("만나서 반가워요 👋")
                                    .font(.PretendardSemiBold24)
                                    .foregroundColor(.grey06)
                                Text("회원님의 정보를 입력해주세요.")
                                    .font(.PretendardRegular20)
                                    .foregroundColor(.grey03)
                            }
                            .padding(.horizontal)

                            // 닉네임 입력
                            InputFieldView(
                                title: {
                                    Text("닉네임")
                                        .font(.PretendardMedium18)
                                        .foregroundColor(.grey06)
                                },
                                placeholder: "닉네임을 입력하세요.",
                                text: $nickname
                            )
                            .padding(.top, 16)
                            .padding(.horizontal)
                            .focused($focusedField, equals: .nickname)

                            // 나이 + 성별
                            HStack(alignment: .top, spacing: 12) {
                                InputFieldView(
                                    title: {
                                        Text("나이")
                                            .font(.PretendardMedium18)
                                            .foregroundColor(.grey06)
                                    },
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
                        .padding(.bottom, 20)
                    }

                    // (3) 하단 버튼
                    MainButton(
                        color: nextButtonColor,
                        text: "다음",
                        textColor: nextButtonTextColor
                    ) {
                        if isFormValid {
                            print("다음 화면 이동")
                        }
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .scrollDismissesKeyboard(.interactively) // iOS 15+ 자동 키보드 관리
            .onTapGesture { hideKeyboard() }
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    OnboardingInfoInputView()
}
