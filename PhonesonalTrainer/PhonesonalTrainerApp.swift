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
    
    var body: some Scene {
        WindowGroup {
            // ✅ 이미 로그인된 경우 온보딩 입력 화면으로 시작
            if UserDefaults.standard.string(forKey: "accessToken") != nil {
                OnboardingInfoInputView(viewModel: OnboardingViewModel())
            } else {
                OnboardingStartView()
            }
        }
    }
}
