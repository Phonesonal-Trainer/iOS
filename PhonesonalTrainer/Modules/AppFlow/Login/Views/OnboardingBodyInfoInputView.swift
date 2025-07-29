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
        isHeightValid && isWeightValid
    }

    private var isHeightValid: Bool {
        if let value = Double(height), value >= 100, value <= 250 {
            return true
        }
        return false
    }

    private var isWeightValid: Bool {
        if let value = Double(weight), value >= 30, value <= 300 {
            return true
        }
        return false
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
                            .foregroundStyle(Color.grey05)
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
                                .foregroundStyle(Color.grey06)
                            Text("인바디 수치를 기반으로 입력해주세요.")
                                .font(.PretendardRegular20)
                                .foregroundStyle(Color.grey03)
                        }
                        .padding(.horizontal)

                        // 입력 폼
                        VStack(spacing: 48) {
                            HStack(spacing: 12) {
                                // 신장
                                InputFieldView(
                                    title: {
                                        Text("신장")
                                            .font(.PretendardMedium18)
                                            .foregroundStyle(Color.grey06)
                                        + Text(" *")
                                            .font(.PretendardMedium18)
                                            .foregroundStyle(Color.orange05)
                                    },
                                    placeholder: "",
                                    text: $height,
                                    keyboardType: .decimalPad,
                                    suffixText: "cm"
                                )
                                .onChange(of: height) {
                                    height = filterDecimalInput(height, maxDigitsBeforeDecimal: 3)
                                }

                                // 몸무게
                                InputFieldView(
                                    title: {
                                        Text("몸무게")
                                            .font(.PretendardMedium18)
                                            .foregroundStyle(Color.grey06)
                                        + Text(" *")
                                            .font(.PretendardMedium18)
                                            .foregroundStyle(Color.orange05)
                                    },
                                    placeholder: "",
                                    text: $weight,
                                    keyboardType: .decimalPad,
                                    suffixText: "kg"
                                )
                                .onChange(of: weight) {
                                    weight = filterDecimalInput(weight, maxDigitsBeforeDecimal: 3)
                                }
                            }

                            // 선택 입력 (체지방률, 골격근량)
                            HStack(spacing: 12) {
                                InputFieldView(
                                    title: {
                                        Text("체지방률")
                                            .font(.PretendardMedium18)
                                            .foregroundStyle(Color.grey06)
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
                                            .foregroundStyle(Color.grey06)
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

    /// 소수점 한자리까지만 허용하고 숫자 외 문자는 제거
    func filterDecimalInput(_ input: String, maxDigitsBeforeDecimal: Int) -> String {
        var value = input.filter { "0123456789.".contains($0) }

        // 소수점 중복 제거
        if value.components(separatedBy: ".").count > 2 {
            value.removeLast()
        }

        // 소수점 자리수 제한
        if let dotIndex = value.firstIndex(of: ".") {
            let decimalPart = value[value.index(after: dotIndex)...]
            if decimalPart.count > 1 {
                value = String(value.prefix(value.distance(from: value.startIndex, to: dotIndex) + 2))
            }
        }

        // 정수부 자리수 제한
        if let dotIndex = value.firstIndex(of: ".") {
            let intPart = value[..<dotIndex]
            if intPart.count > maxDigitsBeforeDecimal {
                value = String(intPart.prefix(maxDigitsBeforeDecimal)) + "." + value[dotIndex...].dropFirst()
            }
        } else if value.count > maxDigitsBeforeDecimal {
            value = String(value.prefix(maxDigitsBeforeDecimal))
        }

        return value
    }
}

#Preview {
    OnboardingBodyInfoInputView()
}
