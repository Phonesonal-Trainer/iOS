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
    
    var body: some Scene {
        WindowGroup {
            OnboardingStartView()
                .environmentObject(userProfile)
                .environmentObject(weightStore)                // ✅ 주입
                .task {
                                    let saved = UserDefaults.standard.integer(forKey: "userId")
                                    if saved != 0 {
                                        await weightStore.configure(userId: saved)
                                    }
                                }
                        }
                    }
                }
