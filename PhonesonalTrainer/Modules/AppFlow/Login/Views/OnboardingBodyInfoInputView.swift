//
//  OnboardingBodyInfoInputView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

struct OnboardingBodyInfoInputView: View {
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var bodyFat: String = ""
    @State private var muscleMass: String = ""

    var isFormValid: Bool {
        !height.isEmpty && !weight.isEmpty
    }

    private let totalPages = 4
    private let currentPage = 2 // 예: 3단계

    var body: some View {
        NavigationStack {
            ZStack {
                Color.grey00.ignoresSafeArea()

                VStack(spacing: 0) {
                    // (1) NavigationBar
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
                                Text("체형 정보를 입력해주세요.")
                                    .font(.PretendardSemiBold24)
                                    .foregroundColor(.grey06)
                                Text("인바디 수치를 기반으로 입력해주세요.")
                                    .font(.PretendardRegular20)
                                    .foregroundColor(.grey03)
                            }
                            .padding(.horizontal)

                            // 입력 폼 (2 x 2 Grid)
                            VStack(spacing: 48) {
                                HStack(spacing: 12) {
                                    InputFieldView(
                                        title: {
                                            Text("신장")
                                                .font(.PretendardMedium18)
                                                .foregroundColor(.grey06)
                                            + Text(" *")
                                                .font(.PretendardMedium18)
                                                .foregroundColor(.orange05)
                                        },
                                        placeholder: "",
                                        text: $height,
                                        keyboardType: .numberPad,
                                        suffixText: "cm"
                                    )

                                    InputFieldView(
                                        title: {
                                            Text("몸무게")
                                                .font(.PretendardMedium18)
                                                .foregroundColor(.grey06)
                                            + Text(" *")
                                                .font(.PretendardMedium18)
                                                .foregroundColor(.orange05)
                                        },
                                        placeholder: "",
                                        text: $weight,
                                        keyboardType: .numberPad,
                                        suffixText: "kg"
                                    )
                                }

                                HStack(spacing: 12) {
                                    InputFieldView(
                                        title: {
                                            Text("체지방률")
                                                .font(.PretendardMedium18)
                                                .foregroundColor(.grey06)
                                        },
                                        placeholder: "",
                                        text: $bodyFat,
                                        keyboardType: .decimalPad,
                                        suffixText: "%"
                                    )

                                    InputFieldView(
                                        title: {
                                            Text("골격근량")
                                                .font(.PretendardMedium18)
                                                .foregroundColor(.grey06)
                                        },
                                        placeholder: "",
                                        text: $muscleMass,
                                        keyboardType: .decimalPad,
                                        suffixText: "kg"
                                    )
                                }
                            }
                            .padding(.top, 24)
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 20) // 하단 여백 추가
                    }

                    // (3) 하단 버튼
                    MainButton(
                        color: isFormValid ? Color.grey05 : Color.grey01,
                        text: "다음",
                        textColor: isFormValid ? .white : .grey02
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
        }
    }
}

#Preview {
    OnboardingBodyInfoInputView()
}
