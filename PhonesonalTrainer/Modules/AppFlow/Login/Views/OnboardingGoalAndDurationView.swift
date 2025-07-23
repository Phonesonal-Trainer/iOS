//
//  OnboardingGoalAndDurationView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/17/25.
//

import SwiftUI

enum Goal: String, CaseIterable, Identifiable {
    case loseWeight = "체중감량"
    case escapeSkinnyFat = "마른비만 탈출"
    case bulkUp = "벌크업"

    var id: String { rawValue }

    var selectedColor: Color {
        .orange04
    }
    var unselectedColor: Color {
        .grey01
    }
    var selectedTextColor: Color {
        .grey0
    }
    var unselectedTextColor: Color {
        .grey03
    }

    var selectedFont: Font {
        .PretendardRegular18
    }
    var unselectedFont: Font {
        .PretendardRegular18
    }
}

struct OnboardingGoalAndDurationView: View {
    let nickname: String

    @State private var selectedGoal: Goal? = nil
    @State private var selectedDuration: String = "1개월"
    @State private var showDurationSheet = false

    var isFormValid: Bool {
        selectedGoal != nil && !selectedDuration.isEmpty
    }

    var body: some View {
        ZStack {
            Color.grey0.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 24) {
                        
                        BackHeaderView {
                            // 뒤로가기 로직
                        }

                        // 페이지 인디케이터
                        HStack(spacing: 8) {
                            Capsule().fill(Color.orange04).frame(width: 80, height: 3)
                            Capsule().fill(Color.orange04).frame(width: 80, height: 3)
                            Capsule().fill(Color.grey01).frame(width: 80, height: 3)
                            Capsule().fill(Color.grey01).frame(width: 80, height: 3)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                        // 닉네임 문구
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(nickname) 회원님,")
                                .font(.PretendardSemiBold24)
                                .foregroundColor(.grey05)
                            Text("당신에 대해 알려주세요.")
                                .font(.PretendardRegular20)
                                .foregroundColor(.grey03)
                        }
                        .padding(.top, 12)

                        // 앱 사용 목적
                        VStack(alignment: .leading, spacing: 20) {
                            Text("앱 사용 목적")
                                .font(.PretendardMedium18)
                                .foregroundColor(.grey06)

                            HStack(spacing: 12) {
                                ForEach(Goal.allCases) { goal in
                                    Button(action: {
                                        selectedGoal = goal
                                    }) {
                                        Text(goal.rawValue)
                                            .font(selectedGoal == goal ? goal.selectedFont : goal.unselectedFont)
                                            .foregroundColor(selectedGoal == goal ? goal.selectedTextColor : goal.unselectedTextColor)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(selectedGoal == goal ? goal.selectedColor : goal.unselectedColor)
                                            )
                                    }
                                }
                            }
                        }
                        .padding(.top, 16)

                        // 목표 기간
                        VStack(alignment: .leading, spacing: 20) {
                            Text("목표 기간")
                                .font(.PretendardMedium18)
                                .foregroundColor(.grey05)

                            Button(action: {
                                showDurationSheet.toggle()
                            }) {
                                HStack {
                                    Text(selectedDuration)
                                        .font(.PretendardRegular18)
                                        .foregroundColor(.grey05)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.grey03)
                                }
                                .padding()
                                .frame(width: 340, height: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.grey02, lineWidth: 1)
                                )
                            }
                        }
                        .padding(.top, 16)
                    }
                    .padding(.top, 12)

                    Spacer()

                    // 다음 버튼
                    Button(action: {
                        // 다음 화면 이동
                    }) {
                        Text("다음")
                            .font(.PretendardSemiBold16)
                            .foregroundColor(isFormValid ? .grey0 : .grey02)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(isFormValid ? Color.grey05 : Color.grey01)
                            .cornerRadius(30)
                    }
                    .disabled(!isFormValid)
                    //.padding(.bottom, 128)
                }
                .padding(.horizontal, 28)
            }
            .sheet(isPresented: $showDurationSheet) {
                DurationSheetView(selected: $selectedDuration, isPresented: $showDurationSheet)
            }
        }
    }
}

#Preview {
    OnboardingGoalAndDurationView(nickname: "서연")
}
