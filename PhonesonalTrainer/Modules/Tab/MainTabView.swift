//
//  MainBarView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/14/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection: Int = 0
    @State private var homePath: [HomeRoute] = []
    @State private var workoutPath: [WorkoutRoutineRoute] = []
    @State private var mealPath: [MealPlanRoute] = []
    @State private var reportPath: [ReportRoute] = []
    
    var body: some View {
        TabView(selection : $selection){
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
            NavigationStack(path: $workoutPath){
                WorkoutRoutineView(path: $workoutPath)
            }
            .tabItem {
                Image(selection == 1 ? "icon2" : "icon2_2")
                Text("운동 루틴")
            }
            .tag(1)
            /// 식단 플랜
            NavigationStack(path: $mealPath){
                MealPlanView(path: $mealPath)
            }
            .tabItem {
                Image(selection == 2 ? "icon3" : "icon3_2")
                Text("식단 플랜")
            }
            .tag(2)
            /// 리포트
            NavigationStack(path: $reportPath){
                ReportView(path: $reportPath)
            }
            .tabItem {
                Image(selection == 3 ? "icon4" : "icon4_2")
                Text("리포트")
            }
            .tag(3)
        }
        .tint(Color("orange05"))
    }
}



struct ReportView: View {
    @Binding var path: [ReportRoute]
    var body: some View {
        Text("Report Screen")
    }
}

#Preview {
    MainTabView()
        .environmentObject(MyPageViewModel())  // ✅ 새로 추가된 전역
        .environmentObject(BodyWeightStore())  // 이미 쓰고 있으면 필요
        .environmentObject(BodyPhotoStore())   // 이미 쓰고 있으면 필요
}
