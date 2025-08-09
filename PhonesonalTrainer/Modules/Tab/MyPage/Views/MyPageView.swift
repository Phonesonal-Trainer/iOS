//
//  MyPageView.swift
//  PhonesonalTrainer
//

import SwiftUI

struct MyPageView: View {
    // 팝업 상태
    @State private var showReset = false
    @State private var showLogout = false

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
            

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // 1) 헤더 (더미)
                    MyPageHeaderView(
                        name: dummyName,
                        goalText: dummyGoalText,
                        durationText: dummyDurationText,
                        onChevronTap: {
                            // TODO: 프로필 이동 (나중에)
                        }
                    )

                    // ↓ 25
                    Spacer().frame(height: 25)

                    // 구분 박스 (높이 10, grey01)
                    Rectangle()
                        .fill(Color.grey01)
                        .frame(height: 10)

                    // ↓ 25
                    Spacer().frame(height: 25)

                    // 2) 주차 진행 (더미)
                    WeeksProgressView(
                        signUpDate: dummySignUpDate,
                        targetWeeks: dummyTargetWeeks
                    )
                    // TODO: API 연결 후 서버 값으로 교체

                    // ↓ 25
                    Spacer().frame(height: 25)

                    // 3) 내 목표
                    MyGoalView(
                                           data: dummyGoalData,
                                           onSeeAll: {
                                               // TODO: 전체 보기 이동
                                           }
                                       )

                    // ↓ 25
                    Spacer().frame(height: 25)

                    // 4) 텍스트 버튼들 (왼쪽 정렬)
                    Button { showReset = true } label: {
                        Text("목표 리셋 후 재시작")
                            .font(.system(size: 14))
                            .foregroundStyle(.grey05)
                    }
                    .contentShape(Rectangle())

                    // ↓ 10
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
                    onRestart: {
                        showReset = false
                        // TODO: 리셋 + 온보딩 이동 (나중에)
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }

            // ====== Logout 팝업 ======
            if showLogout {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture { showLogout = false }

                LogoutPopup(
                    onCancel: { showLogout = false },
                    onRestart: {
                        showLogout = false
                        // TODO: 로그아웃 처리 + 온보딩 이동 (나중에)
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showReset)
        .animation(.easeInOut(duration: 0.2), value: showLogout)
    }
}

#Preview {
    MyPageView() // 프리뷰에서도 더미로 바로 확인
}
