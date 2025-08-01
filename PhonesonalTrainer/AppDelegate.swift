//
//  AppDelegate.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/31/25.
//


import UIKit
import KakaoSDKCommon

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        KakaoSDK.initSDK(appKey: "3c6bef4565fce30adaa67f8e76660298")
        return true
    }
}
