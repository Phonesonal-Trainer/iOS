//
//  HomeView.swift
//  PhonesonalTrainer
//

import SwiftUI

struct HomeScreenView: View {
    @Binding var path: [HomeRoute]

    // 홈 뷰모델
    @StateObject private var vm = HomeViewModel()

    // 전역 몸무게 스토어 (App에서 environmentObject 주입 필요)
    @EnvironmentObject var weightStore: BodyWeightStore

    // 팝업 상태
    @State private var showWeightPopup = false
    @State private var weightText = ""

   
    var body: some View {
        ZStack {
            Color.grey01.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 25) {
                        // 헤더
                        HomeHeaderView(
                            week: vm.presentWeek,
                            dateText: vm.koreanDate.isEmpty ? vm.dateString : vm.koreanDate
                        )

                        // 코멘트
                        TrainerCommentView(comment: vm.comment)

                        // 탭 (vm 주입)
                        HomeTabView()
                            .environmentObject(vm)

                        // ✅ 오늘 상태 (WeightInfoView 포함)
                        DailyStatusView(
                            currentWeight: weightStore.currentWeight,
                            goalWeight: weightStore.goalWeight,
                            todayCalories: vm.todayCalories,     
                                                       targetCalories: vm.targetCalories,
                            onWeightTap: {
                                // 팝업 열기 전에 현재 값 채워주기
                                weightText = String(format: "%.1f", weightStore.currentWeight)
                                showWeightPopup = true
                            }
                        )

                        BodyPicView()

                        Spacer(minLength: 80)
                    }
                    .frame(width: 340)
                    .padding(.vertical, 20)
                }
                .scrollIndicators(.hidden)
            }

            // ✅ 몸무게 입력 팝업
            if showWeightPopup {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture { showWeightPopup = false }

                WeightPopupView(
                    weightText: $weightText,
                    onCancel: { showWeightPopup = false },
                    onSave: { newWeight in
                        Task { @MainActor in
                                    let ok = await weightStore.save(newWeight)   // 서버 저장(비동기)
                                    if ok {
                                        // UI 상태 업데이트는 메인에서
                                        weightText = ""
                                        showWeightPopup = false

                                        // 최신 데이터 재조회
                                        await weightStore.refresh()
                                        await vm.refreshAfterWeightChange()
                            }
                        }
                    }
                )
            }
        }
        .task {
            let userId = UserDefaults.standard.integer(forKey: "userId")
            await vm.load(userId: userId)
            // 홈 진입 시 최신 몸무게 동기화(로그인/온보딩 이후 userId 세팅되어 있다고 가정)
            await weightStore.refresh()
        }
    }
}

#Preview {
    // 미리보기용 path 바인딩 래퍼는 네 프로젝트에 이미 있음(예: StatefulPreviewWrapper)
    StatefulPreviewWrapper([HomeRoute]()) { path in
        HomeScreenView(path: path)
            .environmentObject(BodyWeightStore(userId: 1, goalWeight: 60)) // ✅ 프리뷰 주입
    }
}
