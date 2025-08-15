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
    
    @StateObject private var userProfile = UserProfileViewModel()
    @StateObject private var myPageViewModel = MyPageViewModel()
    @StateObject private var weightStore = BodyWeightStore()
    @StateObject private var bodyPhoto = BodyPhotoStore()     // ✅ 눈바디 로컬 저장소
    @StateObject private var workoutListVM = WorkoutListViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                // ✅ 항상 로그인 화면부터 시작 (사용자가 로그인 선택)
                OnboardingStartView()
            }
            .onAppear {
                // 🔄 앱 시작시 기존 토큰 클리어 - 모든 사용자가 처음부터 시작
                UserDefaults.standard.removeObject(forKey: "accessToken")
                UserDefaults.standard.removeObject(forKey: "refreshToken")
                print("🔄 기존 토큰 클리어 완료 - 새로운 로그인 시작")
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
