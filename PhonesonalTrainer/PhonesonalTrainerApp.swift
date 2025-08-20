//
//  PhonesonalTrainerApp.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/8/25.
//

import SwiftUI

@main
struct PhonesonalTrainerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // ✅ 필수!
    @AppStorage("accessToken") private var accessToken: String = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    @StateObject private var userProfile = UserProfileViewModel()
    @StateObject private var myPageViewModel = MyPageViewModel()
    @StateObject private var weightStore = BodyWeightStore()
    @StateObject private var bodyPhoto = BodyPhotoStore()     // ✅ 눈바디 로컬 저장소
    @StateObject private var workoutListVM = WorkoutListViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                // ✅ 온보딩 완료 여부까지 확인하여 메인 진입 게이트
                if !accessToken.isEmpty && hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingStartView()
                }
            }
            .onAppear {
                // 🔧 테스트용: 앱 시작할 때마다 토큰 클리어
                print("🔧 테스트 모드: 기존 토큰들 클리어")
                UserDefaults.standard.removeObject(forKey: "accessToken")
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "refreshToken")
                UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                UserDefaults.standard.removeObject(forKey: "userId")
            }
            // 🔗 공통 주입/작업은 여기 한 번만
            .environmentObject(userProfile)
            .environmentObject(myPageViewModel)
            .environmentObject(weightStore)
            .environmentObject(bodyPhoto) // ✅ BodyPhotoStore 주입
            .environmentObject(workoutListVM)
            .task {
                // 저장된 userId가 있으면 몸무게 스토어 설정
                let saved = UserDefaults.standard.integer(forKey: "userId")
                if saved != 0 {
                    await weightStore.configure(userId: saved)
                }
            }
        }
    }
}
