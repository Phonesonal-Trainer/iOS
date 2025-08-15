//
//  OnboardingGoalAndDurationView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/17/25.
//

import SwiftUI

struct OnboardingGoalAndDurationView: View {
    let nickname: String
    @ObservedObject var viewModel: OnboardingViewModel

    @State private var selectedGoal: Goal? = nil
    @State private var selectedDuration: Duration = .oneMonth
    @State private var showDurationSheet = false
    @State private var navigateToNext = false

    // ✅ 새로 추가: ViewModel 인스턴스 생성
    //@StateObject private var viewModel = OnboardingViewModel()

    private let totalPages = 4
    private let currentPage = 1

    var isFormValid: Bool {
        selectedGoal != nil
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    NavigationBar(title: nil, hasDefaultBackAction: true) {
                        Image(systemName: "chevron.left")
                            .font(.PretendardMedium22)
                            .foregroundColor(.grey05)
                    }

                    VStack(alignment: .leading, spacing: 24) {
                        PageIndicator(totalPages: totalPages, currentPage: currentPage, activeColor: .orange05, inactiveColor: .grey01)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(nickname) 회원님,")
                                .font(.PretendardSemiBold24)
                                .foregroundStyle(Color.grey06)
                            Text("당신에 대해 알려주세요.")
                                .font(.PretendardRegular20)
                                .foregroundStyle(Color.grey03)
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            Text("앱 사용 목적")
                                .font(.PretendardMedium18)
                                .foregroundStyle(Color.grey06)

                            HStack(spacing: 12) {
                                ForEach(Goal.allCases) { goal in
                                    Button(action: {
                                        selectedGoal = goal
                                    }) {
                                        Text(goal.rawValue)
                                            .font(.PretendardRegular18)
                                            .foregroundColor(selectedGoal == goal ? .grey00 : .grey03)
                                            .frame(height: 40)
                                            .padding(.horizontal, 16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(selectedGoal == goal ? .orange05 : .grey01)
                                            )
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            Text("목표 기간")
                                .font(.PretendardMedium18)
                                .foregroundStyle(Color.grey06)

                            Button(action: {
                                withAnimation(.easeInOut) {
                                    showDurationSheet.toggle()
                                }
                            }) {
                                HStack {
                                    Text(selectedDuration.rawValue)
                                        .font(.PretendardRegular18)
                                        .foregroundStyle(Color.grey05)
                                    Spacer()
                                    Image(systemName: showDurationSheet ? "chevron.up" : "chevron.down")
                                        .foregroundStyle(Color.grey03)
                                }
                                .padding(.horizontal)
                                .frame(height: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(showDurationSheet ? Color.orange05 : Color.grey02, lineWidth: 1)
                                )
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    MainButton(
                        color: isFormValid ? Color.grey05 : Color.grey01,
                        text: "다음",
                        textColor: isFormValid ? .white : .grey02
                    ) {
                        if isFormValid {
                            // ViewModel에 목표와 기간 저장
                            viewModel.purpose = selectedGoal?.rawValue ?? ""
                            viewModel.deadline = durationToDays(selectedDuration)
                            navigateToNext = true
                        }
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }

                if showDurationSheet {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                showDurationSheet = false
                            }
                        }

                    VStack {
                        Spacer()
                        DurationSheetView(selected: $selectedDuration, isPresented: $showDurationSheet)
                            .frame(maxWidth: .infinity)
                            .transition(.move(edge: .bottom))
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }

            // ✅ 여기서 viewModel 전달!
            .navigationDestination(isPresented: $navigateToNext) {
                OnboardingBodyInfoInputView(viewModel: viewModel)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Helper Functions
    private func durationToDays(_ duration: Duration) -> Int {
        switch duration {
        case .oneMonth:
            return 30
        case .threeMonths:
            return 90
        case .sixMonths:
            return 180
        }
    }
}

#Preview {
    OnboardingGoalAndDurationView(nickname: "홍길동", viewModel: OnboardingViewModel())
}
