//
//  OnboardingInfoInputView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//

import SwiftUI
import Combine

struct OnboardingInfoInputView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var nickname: String = ""
    @State private var age: String = ""
    @State private var selectedGender: Gender? = nil
    @FocusState private var focusedField: Field?

    @State private var navigateToNext = false
    @State private var nicknameShake = false
    @State private var ageShake = false

    enum Field {
        case nickname
        case age
    }

    private let currentPage = 0
    private let totalPages = 4

    // MARK: - 유효성 검사
    var isFormFilled: Bool {
        !nickname.isEmpty && !age.isEmpty && selectedGender != nil
    }

    var isNicknameValid: Bool {
        let regex = "^[가-힣a-zA-Z]{1,7}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
    }

    var isAgeValid: Bool {
        if let ageNum = Int(age) {
            return ageNum >= 10 && ageNum <= 99
        }
        return false
    }

    var nextButtonColor: Color {
        isFormFilled ? .grey05 : .grey01
    }

    var nextButtonTextColor: Color {
        isFormFilled ? .grey00 : .grey02
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.grey00.ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - 상단 NavigationBar
                    NavigationBar(title: nil, hasDefaultBackAction: true) {
                        Image(systemName: "chevron.left")
                            .font(.PretendardMedium22)
                            .foregroundColor(.grey05)
                    }

                    // MARK: - 스크롤 가능한 입력 영역
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            PageIndicator(
                                totalPages: totalPages,
                                currentPage: currentPage,
                                activeColor: .orange05,
                                inactiveColor: .grey01
                            )

                            VStack(alignment: .leading, spacing: 6) {
                                Text("만나서 반가워요 👋")
                                    .font(.PretendardSemiBold24)
                                    .foregroundStyle(Color.grey06)
                                Text("회원님의 정보를 입력해주세요.")
                                    .font(.PretendardRegular20)
                                    .foregroundStyle(Color.grey03)
                            }

                            // MARK: - 닉네임 입력
                            InputFieldView(
                                title: {
                                    Text("닉네임")
                                        .font(.PretendardMedium18)
                                        .foregroundStyle(Color.grey06)
                                },
                                placeholder: "닉네임을 입력하세요.",
                                text: $nickname
                            )
                            .offset(x: nicknameShake ? -10 : 0)
                            .animation(.default, value: nicknameShake)
                            .onReceive(Just(nickname)) { _ in
                                if nickname.count > 7 {
                                    nickname = String(nickname.prefix(7))
                                }
                            }
                            .focused($focusedField, equals: .nickname)
                            .padding(.top, 16)

                            // MARK: - 나이 + 성별
                            HStack(alignment: .top, spacing: 12) {
                                InputFieldView(
                                    title: {
                                        Text("나이")
                                            .font(.PretendardMedium18)
                                            .foregroundStyle(Color.grey06)
                                    },
                                    placeholder: "",
                                    text: $age,
                                    keyboardType: .numberPad,
                                    suffixText: "세"
                                )
                                .offset(x: ageShake ? -10 : 0)
                                .animation(.default, value: ageShake)
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

                            Spacer().frame(height: 40)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }

                // MARK: - 하단 버튼
                VStack {
                    Spacer()
                    MainButton(
                        color: nextButtonColor,
                        text: "다음",
                        textColor: nextButtonTextColor
                    ) {
                        if isFormFilled && isNicknameValid && isAgeValid {
                            navigateToNext = true
                        } else {
                            if !isNicknameValid {
                                withAnimation { nicknameShake = true }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { nicknameShake = false }
                                focusedField = .nickname
                            } else if !isAgeValid {
                                withAnimation { ageShake = true }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { ageShake = false }
                                focusedField = .age
                            }
                        }
                    }
                    .disabled(!isFormFilled)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .ignoresSafeArea(.keyboard)
            }
            .navigationBarBackButtonHidden(true)
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture { hideKeyboard() }
            .navigationDestination(isPresented: $navigateToNext) {
                OnboardingGoalAndDurationView(nickname: nickname)
            }
        }
    }

    // MARK: - 키보드 내리기
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    OnboardingInfoInputView()
}
