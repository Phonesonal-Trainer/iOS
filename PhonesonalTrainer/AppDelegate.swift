//
//  AppDelegate.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/31/25.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import OSLog

class AppDelegate: NSObject, UIApplicationDelegate {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "PhonesonalTrainer", category: "AppURL")

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // ✅ 카카오 SDK 초기화 (네이티브 앱 키 입력)
        KakaoSDK.initSDK(appKey: "3c6bef4565fce30adaa67f8e76660298")
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        // ✅ 어떤 스킴이든 들어온 URL 자체를 먼저 로깅
        logger.info("[URL] openURL 호출 · url=\(url.absoluteString, privacy: .public)")
        logQueryItems(of: url)

        // ✅ 카카오 로그인 콜백 처리
        if AuthApi.isKakaoTalkLoginUrl(url) {
            logger.info("[URL] KakaoTalk 로그인 URL 감지 → AuthController.handleOpenUrl 처리 시도")
            let handled = AuthController.handleOpenUrl(url: url)
            logger.info("[URL] AuthController.handleOpenUrl 처리 결과: \(handled)")
            return handled
        }

        // ✅ 기타 커스텀 스킴으로 돌아온 경우에도 true 반환하여 처리됨을 표시
        logger.info("[URL] KakaoTalk URL 아님 · 커스텀 스킴 처리 완료")
        return true
    }

    private func logQueryItems(of url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            logger.debug("[URL] URLComponents 파싱 실패")
            return
        }
        let scheme = components.scheme ?? ""
        let host = components.host ?? ""
        let path = components.path
        logger.info("[URL] scheme=\(scheme, privacy: .public) host=\(host, privacy: .public) path=\(path, privacy: .public)")

        if let items = components.queryItems, !items.isEmpty {
            for item in items {
                let key = item.name
                let value = item.value ?? ""
                logger.info("[URL] query \(key, privacy: .public)=\(value, privacy: .public)")
            }
        } else {
            logger.debug("[URL] query items 없음")
        }
    }
}
