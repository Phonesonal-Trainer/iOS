//
//  MyPageView.swift
//  PhonesonalTrainer
//

import SwiftUI

struct MyPageView: View {
    @StateObject private var vm = MyPageViewModel() // ✅ ViewModel 연결
    @State private var showReset = false
    @State private var showLogout = false
    @State private var goToProfile = false
    @State private var goToGoalView = false

    @EnvironmentObject var user: UserProfileViewModel
    @EnvironmentObject var weightStore: BodyWeightStore   // ▶️ 추가: 전역 몸무게 스토어

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            if vm.isLoading {
                ProgressView()
            } else if let err = vm.errorText {
                VStack(spacing: 12) {
                    Text(err)
                        .foregroundStyle(.grey05)
                    Button("다시 시도") {
                        Task { await vm.load() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // 1) 헤더
                        MyPageHeaderView(
                            name: vm.name,
                            goalText: vm.goalText,
                            durationText: vm.durationText,
                            onChevronTap: { goToProfile = true }
                        )

                        Spacer().frame(height: 25)

                        Rectangle()
                            .fill(Color.grey01)
                            .frame(height: 10)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, -25)

                        Spacer().frame(height: 25)

                        // 2) 주차 진행
                        WeeksProgressView(
                            signUpDate: vm.signUpDate,
                            targetWeeks: vm.targetWeeks
                        )

                        Spacer().frame(height: 25)

                        // ▶️ 추가: 2.5) 몸무게(전역 값) 섹션
                        VStack(alignment: .leading, spacing: 12) {
                            Text("몸무게")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.grey05)

                            HStack(spacing: 16) {
                                // 현재
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("현재")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.grey03)
                                    Text("\(String(format: "%.1f", weightStore.currentWeight)) kg")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.grey05)
                                }

                                Rectangle()
                                    .fill(Color.grey01)
                                    .frame(width: 1, height: 24)

                                // 목표
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("목표")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.grey03)
                                    Text("\(String(format: "%.1f", weightStore.goalWeight)) kg")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.grey05)
                                }

                                Spacer()

                                // 차이
                                let diff = weightStore.currentWeight - weightStore.goalWeight
                                Text(String(format: "%+.1f kg", diff))
                                    .font(.system(size: 12))
                                    .foregroundStyle(.orange05)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(Color.grey00)
                            .cornerRadius(5)
                            .shadow(color: .black.opacity(0.1), radius: 2)
                        }

                        Spacer().frame(height: 25)

                        // 3) 내 목표 (자세히 보기 → GoalView)
                        MyGoalView(
                            data: vm.goalData,
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
        // GoalView 이동
        .background(
            NavigationLink(
                destination: GoalView(
                    recommend: vm.recommend,
                    workout: vm.workout,
                    meal: vm.meal
                ),
                isActive: $goToGoalView
            ) { EmptyView() }
            .hidden()
        )
        .animation(.easeInOut(duration: 0.2), value: showReset)
        .animation(.easeInOut(duration: 0.2), value: showLogout)
        .navigationDestination(isPresented: $goToProfile) {
            MyProfileView()
        }
        .task {
            await vm.load()              // ✅ 기존 데이터 로드
            await weightStore.refresh()  // ▶️ 추가: 전역 몸무게 최신화
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
            .environmentObject(UserProfileViewModel())
            .environmentObject(BodyWeightStore(userId: 1, goalWeight: 60)) // ▶️ 프리뷰 주입 필수
    }
}
