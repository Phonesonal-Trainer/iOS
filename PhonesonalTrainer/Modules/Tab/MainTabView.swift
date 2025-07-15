//
//  MainBarView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/14/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection : $selection){
            HomeView()
                .tabItem {
                    Image(selection == 0 ? "icon1" : "icon1_2")
                    Text("홈")
                }
                .tag(0)
            
            WorkoutRoutineView()
                .tabItem {
                    Image(selection == 1 ? "icon2" : "icon2_2")
                    Text("운동 루틴")
                }
                .tag(1)
            
            MealPlanView()
                .tabItem {
                    Image(selection == 2 ? "icon3" : "icon3_2")
                    Text("식단 플랜")
                }
                .tag(2)
            
            ReportView()
                .tabItem {
                    Image(selection == 3 ? "icon4" : "icon4_2")
                    Text("리포트")
                }
                .tag(3)
        }
        .tint(Color("orange04"))
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home Screen")
    }
}
struct WorkoutRoutineView: View {
    var body: some View {
        Text("WorkoutRoutine Screen")
    }
}
struct ReportView: View {
    var body: some View {
        Text("Report Screen")
    }
}

#Preview {
    MainTabView()
}
