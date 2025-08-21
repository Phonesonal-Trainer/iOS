//
//  OnboardingBodyInfoInputView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI
import Combine

struct OnboardingBodyInfoInputView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    @State private var goToDiagnosis = false

    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss

    @State private var shakeHeight = false
    @State private var shakeWeight = false
    @State private var showErrorAlert = false

    private let totalPages = 4
    private let currentPage = 2

    enum Field {
        case height, weight, bodyFat, muscleMass
    }

    var isHeightValid: Bool {
        if let value = Double(viewModel.height), value >= 100, value <= 250 {
            return true
        }
        return false
    }

    var isWeightValid: Bool {
        if let value = Double(viewModel.weight), value >= 30, value <= 300 {
            return true
        }
        return false
    }

    var isFormFilled: Bool {
        !viewModel.height.isEmpty && !viewModel.weight.isEmpty
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.grey00
                .ignoresSafeArea()
                .onTapGesture {
                    focusedField = nil
                }

            VStack(spacing: 0) {
                // 상단 네비게이션 바
                NavigationBar(title: nil, hasDefaultBackAction: false) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.PretendardMedium22)
                            .foregroundColor(.grey05)
                    }
                }

                VStack(alignment: .leading, spacing: 24) {
                    PageIndicator(
                        totalPages: totalPages,
                        currentPage: currentPage,
                        activeColor: .orange05,
                        inactiveColor: .grey01
                    )

                    VStack(alignment: .leading, spacing: 6) {
                        Text("체형 정보를 입력해주세요.")
                            .font(.PretendardSemiBold24)
                            .foregroundStyle(Color.grey06)
                        Text("인바디 수치를 기반으로 입력해주세요.")
                            .font(.PretendardRegular20)
                            .foregroundStyle(Color.grey03)
                    }

                    // 신장 + 몸무게
                    HStack(spacing: 12) {
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
                            text: $viewModel.height,
                            keyboardType: .decimalPad,
                            suffixText: "cm"
                        )
                        .offset(x: shakeHeight ? -10 : 0)
                        .animation(.default, value: shakeHeight)
                        .focused($focusedField, equals: .height)
                        .onChange(of: viewModel.height) {
                            viewModel.height = filterDecimalInput(viewModel.height, maxDigitsBeforeDecimal: 3)
                        }

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
                            text: $viewModel.weight,
                            keyboardType: .decimalPad,
                            suffixText: "kg"
                        )
                        .offset(x: shakeWeight ? -10 : 0)
                        .animation(.default, value: shakeWeight)
                        .focused($focusedField, equals: .weight)
                        .onChange(of: viewModel.weight) {
                            viewModel.weight = filterDecimalInput(viewModel.weight, maxDigitsBeforeDecimal: 3)
                        }
                    }

                    // 체지방률 + 골격근량
                    HStack(spacing: 12) {
                        InputFieldView(
                            title: {
                                Text("체지방률")
                                    .font(.PretendardMedium18)
                                    .foregroundStyle(Color.grey06)
                            },
                            placeholder: "",
                            text: $viewModel.bodyFat,
                            keyboardType: .decimalPad,
                            suffixText: "%"
                        )
                        .focused($focusedField, equals: .bodyFat)

                        InputFieldView(
                            title: {
                                Text("골격근량")
                                    .font(.PretendardMedium18)
                                    .foregroundStyle(Color.grey06)
                            },
                            placeholder: "",
                            text: $viewModel.muscleMass,
                            keyboardType: .decimalPad,
                            suffixText: "kg"
                        )
                        .focused($focusedField, equals: .muscleMass)
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .frame(maxHeight: .infinity)
            }

            // 하단 버튼
            MainButton(
                color: isFormFilled ? .grey05 : .grey01,
                text: (viewModel.isLoading || viewModel.isDiagnosisLoading) ? "로딩 중..." : "다음",
                textColor: isFormFilled ? .white : .grey02
            ) {
                if isHeightValid && isWeightValid {
                    // 회원가입 및 진단 API 호출
                    viewModel.signup { signupSuccess in
                        if signupSuccess {
                            // 회원가입 성공 후 진단 API 호출
                            viewModel.callDiagnosisAPI { diagnosisSuccess in
                                if diagnosisSuccess {
                                    print("🎯 진단 성공, diagnosisResult: \(String(describing: viewModel.diagnosisResult))")
                                    goToDiagnosis = true
                                } else {
                                    // 진단 실패 시에도 다음 화면으로 이동 (기본 데이터로)
                                    print("⚠️ 진단 API 실패, 기본 데이터로 진행")
                                    print("🎯 기본 데이터: \(viewModel.toDiagnosisModel())")
                                    goToDiagnosis = true
                                }
                            }
                        } else {
                            showErrorAlert = true
                        }
                    }
                } else {
                    if !isHeightValid {
                        withAnimation { shakeHeight = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            shakeHeight = false
                        }
                        focusedField = .height
                    }
                    if !isWeightValid {
                        withAnimation { shakeWeight = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            shakeWeight = false
                        }
                        if isHeightValid { focusedField = .weight }
                    }
                }
            }
            .disabled(!isFormFilled || viewModel.isLoading)
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToDiagnosis) {
            OnboradingDiagnosisView(
                nickname: viewModel.nickname,
                diagnosis: viewModel.diagnosisResult ?? viewModel.toDiagnosisModel()
            )
        }
        .alert("회원가입 오류", isPresented: $showErrorAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "회원가입 중 오류가 발생했습니다.")
        }
    }

    // MARK: - 입력값 필터링 (소수점, 최대 자릿수 등 제한)
    func filterDecimalInput(_ input: String, maxDigitsBeforeDecimal: Int) -> String {
        var value = input.filter { "0123456789.".contains($0) }

        if value.components(separatedBy: ".").count > 2 {
            value.removeLast()
        }

        if let dotIndex = value.firstIndex(of: ".") {
            let decimalPart = value[value.index(after: dotIndex)...]
            if decimalPart.count > 1 {
                value = String(value.prefix(value.distance(from: value.startIndex, to: dotIndex) + 2))
            }
        }

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

// MARK: - 미리보기
#Preview {
    NavigationStack {
        OnboardingBodyInfoInputView(viewModel: OnboardingViewModel())
    }
}
