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
    @StateObject private var weightStore = BodyWeightStore()
    @StateObject private var bodyPhoto = BodyPhotoStore()     // ✅ 눈바디 로컬 저장소

    var body: some Scene {
        WindowGroup {
            Group {
                // ✅ 이미 로그인된 경우: 온보딩 정보 입력 화면으로 시작
                if UserDefaults.standard.string(forKey: "accessToken") != nil {
                    OnboardingInfoInputView(viewModel: OnboardingViewModel())
                } else {
                    // ✅ 아니면 온보딩 시작 화면
                    OnboardingStartView()
                }
            }
            // 🔗 공통 주입/작업은 여기 한 번만
            .environmentObject(userProfile)
            .environmentObject(weightStore)
            .environmentObject(bodyPhoto) // ✅ BodyPhotoStore 주입
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
