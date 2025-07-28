//
//  OnboardingBodyInfoInputView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI
import Combine

struct OnboardingBodyInfoInputView: View {
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var bodyFat: String = ""
    @State private var muscleMass: String = ""
    
    @State private var goToDiagnosis = false
    @State private var diagnosisModel: DiagnosisModel? = nil

    var isFormValid: Bool {
        height.count >= 2 && weight.count >= 2
    }

    private let totalPages = 4
    private let currentPage = 2

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // NavigationBar
                NavigationBar {
                    Button(action: { print("뒤로가기 버튼 클릭") }) {
                        Image(systemName: "chevron.left")
                            .font(.PretendardMedium22)
                            .foregroundColor(.grey05)
                    }
                }

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

                        // 입력 폼
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
                                .onReceive(Just(height)) { _ in
                                    if height.count > 3 { height = String(height.prefix(3)) }
                                }

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
                                .onReceive(Just(weight)) { _ in
                                    if weight.count > 3 { weight = String(weight.prefix(3)) }
                                }
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
                    .padding(.bottom, 20)
                }

                // 다음 버튼
                MainButton(
                    color: isFormValid ? Color.grey05 : Color.grey01,
                    text: "다음",
                    textColor: isFormValid ? .white : .grey02
                ) {
                    if isFormValid {
                        diagnosisModel = DiagnosisModel(
                            height: height,
                            weight: weight,
                            bodyFat: bodyFat.isEmpty ? nil : bodyFat,
                            muscleMass: muscleMass.isEmpty ? nil : muscleMass
                        )
                        goToDiagnosis = true
                    }
                }
                .disabled(!isFormValid)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color.grey00.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goToDiagnosis) {
                OnboradingDiagnosisView(
                    nickname: "서연",
                    diagnosis: diagnosisModel ?? .dummy
                )
            }
        }
    }
}

#Preview {
    OnboardingBodyInfoInputView()
}
