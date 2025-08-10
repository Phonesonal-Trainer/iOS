//
//  MyPageView.swift
//  PhonesonalTrainer
//

import SwiftUI

struct MyPageView: View {
    // 팝업 상태
    @State private var showReset = false
    @State private var showLogout = false

    // GoalView 이동 상태
    @State private var goToGoalView = false

    // ===== 더미 값=====
    private let dummyName = "서연"
    private let dummyGoalText = "목표 체중 60kg"
    private let dummyDurationText = "3주차"
    private let dummySignUpDate = Date().addingTimeInterval(-60*60*24*21) // 3주 전
    private let dummyTargetWeeks = 12

    private let dummyGoalData = GoalStatsData(
        weight: GoalNumbers(current: 66.6, goal: 60.0),
        bodyFat: GoalNumbers(current: 24.0, goal: 18.0),
        muscle: GoalNumbers(current: 25.0, goal: 27.0),
        bmi: GoalNumbers(current: 1700, goal: 2000)
    )

    // GoalView에 넘길 더미
    private let dummyRecommend = RecommendedGoalsUIModel(
        weightFrom: "55 kg", weightTo: "49 kg", weightDiff: "-6kg",
        bmiFrom: "21.5", bmiTo: "19.1", bmiDiff: "-2.4",
        fatFrom: "30%", fatTo: "22%", fatDiff: "-8%p",
        skeletalTag: "유지 또는 소폭 증가"
    )
    private let dummyWorkout = WorkoutGoalsUIModel(
        routine: "주 3회 / 1시간",
        anaerobic: "주 3회 / 40분",
        aerobic: "주 2회 / 20분"
    )
    private let dummyMeal = MealGoalsUIModel(
        nutrient: "고단백/저지방",
        amount: "1300 ~ 1400 kcal"
    )

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // 1) 헤더
                    MyPageHeaderView(
                        name: dummyName,
                        goalText: dummyGoalText,
                        durationText: dummyDurationText,
                        onChevronTap: { }
                    )

                    Spacer().frame(height: 25)

                    Rectangle().fill(Color.grey01).frame(height: 10)

                    Spacer().frame(height: 25)

                    // 2) 주차 진행
                    WeeksProgressView(
                        signUpDate: dummySignUpDate,
                        targetWeeks: dummyTargetWeeks
                    )

                    Spacer().frame(height: 25)

                    // 3) 내 목표 (자세히 보기 → GoalView)
                    MyGoalView(
                        data: dummyGoalData,
                        onSeeAll: { goToGoalView = true }
                    )

                    Spacer().frame(height: 25)

                    // 4) 텍스트 버튼들
                    Button { showReset = true } label: {
                        Text("목표 리셋 후 재시작")
                            .font(.system(size: 14))
                            .foregroundStyle(.grey05)
                    }
                    .contentShape(Rectangle())

                    Spacer().frame(height: 10)

                    Button { showLogout = true } label: {
                        Text("로그아웃")
                            .font(.system(size: 14))
                            .foregroundStyle(.grey05)
                    }
                    .contentShape(Rectangle())
                }
                .padding(.horizontal, 25)
                .padding(.top, 25)
                .padding(.bottom, 25)
            }

            // ====== Reset 팝업 ======
            if showReset {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture { showReset = false }

                ResetPopup(
                    onCancel: { showReset = false },
                    onRestart: { showReset = false }
                )
                .transition(.scale.combined(with: .opacity))
            }

            // ====== Logout 팝업 ======
            if showLogout {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture { showLogout = false }

                LogoutPopup(
                    onCancel: { showLogout = false },
                    onRestart: { showLogout = false }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        // ✅ 숨겨진 NavigationLink: goToGoalView가 true면 GoalView로 push
        .background(
            NavigationLink(
                destination: GoalView(
                    recommend: dummyRecommend,
                    workout: dummyWorkout,
                    meal: dummyMeal
                ),
                isActive: $goToGoalView
            ) { EmptyView() }
            .hidden()
        )
        .animation(.easeInOut(duration: 0.2), value: showReset)
        .animation(.easeInOut(duration: 0.2), value: showLogout)
    }
}

// ✅ 프리뷰는 NavigationStack으로 감싸야 작동
#Preview {
    NavigationStack {
        MyPageView()
    }
}
