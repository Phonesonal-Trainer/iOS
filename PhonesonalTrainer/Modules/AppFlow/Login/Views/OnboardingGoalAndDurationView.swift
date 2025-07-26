//
//  OnboardingGoalAndDurationView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/17/25.
//

import SwiftUI

struct OnboardingGoalAndDurationView: View {
    let nickname: String

    @State private var selectedGoal: Goal? = nil
    @State private var selectedDuration: Duration = .oneMonth
    @State private var showDurationSheet = false

    var isFormValid: Bool {
        selectedGoal != nil
    }

    private let totalPages = 4
    private let currentPage = 1

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            // NavigationBar 적용
                            NavigationBar {
                                Button(action: {
                                    print("뒤로가기 버튼 클릭")
                                }) {
                                    Image(systemName: "chevron.left")
                                        .font(.PretendardMedium22)
                                        .foregroundColor(.grey05)
                                }
                            }

                            // 페이지 인디케이터
                            PageIndicator(
                                totalPages: totalPages,
                                currentPage: currentPage,
                                activeColor: .orange05,
                                inactiveColor: .grey01
                            )

                            // 닉네임 문구
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(nickname) 회원님,")
                                    .font(.PretendardSemiBold24)
                                    .foregroundColor(.grey06)
                                Text("당신에 대해 알려주세요.")
                                    .font(.PretendardRegular20)
                                    .foregroundColor(.grey03)
                            }
                            .padding(.horizontal)

                            // 앱 사용 목적
                            VStack(alignment: .leading, spacing: 16) {
                                Text("앱 사용 목적")
                                    .font(.PretendardMedium18)
                                    .foregroundColor(.grey06)

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
                            .padding(.top, 16)
                            .padding(.horizontal)

                            // 목표 기간
                            VStack(alignment: .leading, spacing: 16) {
                                Text("목표 기간")
                                    .font(.PretendardMedium18)
                                    .foregroundColor(.grey06)

                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        showDurationSheet.toggle()
                                    }
                                }) {
                                    HStack {
                                        Text(selectedDuration.rawValue)
                                            .font(.PretendardRegular18)
                                            .foregroundColor(.grey05)
                                        Spacer()
                                        Image(systemName: showDurationSheet ? "chevron.up" : "chevron.down")
                                            .foregroundColor(.grey03)
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 52)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(showDurationSheet ? Color.orange05 : Color.grey02, lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.top, 16)
                            .padding(.horizontal)
                        }
                    }

                    // 다음 버튼
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

                // 검정 반투명 배경 + DurationSheetView
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
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    OnboardingGoalAndDurationView(nickname: "서연")
}
