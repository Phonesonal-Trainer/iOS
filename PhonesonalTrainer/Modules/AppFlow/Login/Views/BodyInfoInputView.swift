//
//  BodyInfoInputView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

struct BodyInfoInputView: View {
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
        ZStack {
            Color.grey00.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // (1) 헤더
                        BackHeader {
                            // 뒤로가기 로직
                        }

                        // 페이지 인디케이터
                        PageIndicator(
                            totalPages: totalPages,
                            currentPage: currentPage,
                            activeColor: .orange05,
                            inactiveColor: .grey01
                        )

                        // (2) 타이틀
                        VStack(alignment: .leading, spacing: 6) {
                            Text("체형 정보를 입력해주세요.")
                                .font(.PretendardSemiBold24)
                                .foregroundColor(.grey06)
                            Text("인바디 수치를 기반으로 입력해주세요.")
                                .font(.PretendardRegular20)
                                .foregroundColor(.grey03)
                        }
                        .padding(.horizontal)

                        // (3) 입력 폼 (2 x 2 Grid)
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
                }

                // (4) 하단 버튼
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
    }
}

#Preview {
    BodyInfoInputView()
}
