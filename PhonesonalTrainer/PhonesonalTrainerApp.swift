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
                // 🔧 개발 중에만 필요시 토큰 클리어 (주석 처리)
                print("🔧 앱 onAppear - 현재 상태:")
                print("   - accessToken: '\(accessToken)'")
                print("   - hasCompletedOnboarding: \(hasCompletedOnboarding)")
                
                // 테스트를 위해 토큰들을 강제로 클리어
                print("🔧 테스트 모드: 기존 토큰들 클리어")
                UserDefaults.standard.removeObject(forKey: "accessToken")
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "refreshToken")
                UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                UserDefaults.standard.removeObject(forKey: "userId")
                UserDefaults.standard.removeObject(forKey: "tempToken")
                
                // UserDefaults 동기화
                UserDefaults.standard.synchronize()
                
                print("🔧 클리어 후 상태:")
                print("   - accessToken: '\(UserDefaults.standard.string(forKey: "accessToken") ?? "nil")'")
                print("   - hasCompletedOnboarding: \(UserDefaults.standard.bool(forKey: "hasCompletedOnboarding"))")
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
