//  MainBarView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/14/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var weightStore: BodyWeightStore
    @State private var selection: Int = 0
    @State private var homePath: [HomeRoute] = []
    @State private var workoutPath: [WorkoutRoutineRoute] = []
    @State private var mealPath: [MealPlanRoute] = []
    @State private var reportPath: [ReportRoute] = []

    var body: some View {
        TabView(selection: $selection) {
            /// 홈
            NavigationStack(path: $homePath) {
                HomeScreenView(path: $homePath)
            }
            .tabItem {
                Image(selection == 0 ? "icon1" : "icon1_2")
                Text("홈")
            }
            .tag(0)

            /// 운동 루틴
            NavigationStack(path: $workoutPath) {
                WorkoutRoutineView(path: $workoutPath)
            }
            .tabItem {
                Image(selection == 1 ? "icon2" : "icon2_2")
                Text("운동 루틴")
            }
            .tag(1)

            /// 식단 플랜
            NavigationStack(path: $mealPath) {
                MealPlanView(path: $mealPath)
            }
            .tabItem {
                Image(selection == 2 ? "icon3" : "icon3_2")
                Text("식단 플랜")
            }
            .tag(2)

            /// 리포트
            NavigationStack(path: $reportPath) {
                ReportView(path: $reportPath)
            }
            .tabItem {
                Image(selection == 3 ? "icon4" : "icon4_2")
                Text("리포트")
            }
            .tag(3)
        }
        .tint(Color("orange05"))
        .task {
            // ✅ @EnvironmentObject에는 $ 없음. 그냥 인스턴스 호출
            let saved = UserDefaults.standard.integer(forKey: "userId")
            if saved != 0 {
                // 여기서 userId를 내부에 반영하는 로직이 필요하다면,
                // BodyWeightStore 쪽에서 처리(예: App 시작 시 주입)하는 것을 권장.
                // 안전하게 최신값만 갱신:
                await weightStore.refresh()
            }
        }
    }
}

// ====== Report ======
struct ReportView: View {
    @Binding var path: [ReportRoute]
    var body: some View {
        ReportScreenWrapper(path: $path)
    }
}

struct ReportScreenWrapper: View {
    @Binding var path: [ReportRoute]
    @StateObject private var viewModel = ReportViewModel(apiService: MockReportAPIService())

    var body: some View {
        ReportScreen(viewModel: viewModel)
    }
}

//#Preview {
  //  MainTabView()
        // ✅ 실제로 사용하는 전역만 넣기
    //    .environmentObject(BodyWeightStore(userId: 1, goalWeight: 60))
      //  .environmentObject(BodyPhotoStore())
//}
