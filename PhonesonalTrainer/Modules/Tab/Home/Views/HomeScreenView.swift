//
//  HomeView.swift
//  PhonesonalTrainer
//
import SwiftUI

struct HomeScreenView: View {
    @Binding var path: [HomeRoute]

    // 홈 뷰모델
    @StateObject private var vm = HomeViewModel()

    // 전역 스토어들 (App에서 environmentObject 주입 필요)
    @EnvironmentObject var weightStore: BodyWeightStore
    @EnvironmentObject var bodyPhoto: BodyPhotoStore
    @EnvironmentObject var my: MyPageViewModel

    // 팝업 상태
    @State private var showWeightPopup = false
    @State private var weightText = ""

    var body: some View {
        ZStack {
            Color.grey01.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 25) {
                        // 헤더 (아바타 탭 → 마이페이지)
                        HomeHeaderView(
                            week: vm.presentWeek,
                            dateText: vm.koreanDate.isEmpty ? vm.dateString : vm.koreanDate,
                            onAvatarTap: { path.append(.myPage) }
                        )
                        .environmentObject(my)

                        // 코멘트
                        TrainerCommentView(comment: vm.comment)

                        // 탭 (vm 주입)
                        HomeTabView()
                            .environmentObject(vm)

                        // ✅ 오늘 상태 (WeightInfoView 포함)
                        // DailyStatusView의 currentWeight와 goalWeight 매개변수를 삭제합니다.
                        DailyStatusView(
                            todayCalories: vm.todayCalories,
                            targetCalories: vm.targetCalories,
                            onWeightTap: {
                                // 팝업 열기 전에 현재 값 채워주기
                                weightText = String(format: "%.1f", weightStore.currentWeight)
                                showWeightPopup = true
                            }
                        )

                        // ✅ 눈바디 (환경객체 기반)
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
                            let ok = await weightStore.save(newWeight)  // 서버 저장(비동기)
                            if ok {
                                // UI 상태 업데이트
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

            // 홈 데이터
            await vm.load(userId: userId)

            // 몸무게 동기화
            await weightStore.refresh()

            // ✅ 눈바디 동기화 (서버 → 로컬 today 저장)
            await bodyPhoto.syncTodayFromServer(userId: userId)
        }
        .alert("데이터 로드 실패", isPresented: .constant(vm.errorText != nil)) {
            Button("확인", role: .cancel) {
                vm.errorText = nil
            }
        } message: {
            if let errorText = vm.errorText {
                Text(errorText)
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper([HomeRoute]()) { path in
        HomeScreenView(path: path)
            .environmentObject(BodyWeightStore())
            .environmentObject(BodyPhotoStore())
            .environmentObject(MyPageViewModel())
    }
}
