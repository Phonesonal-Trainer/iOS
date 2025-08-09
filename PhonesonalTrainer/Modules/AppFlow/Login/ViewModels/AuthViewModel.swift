//
//  AuthViewModel.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/1/25.
//

import KakaoSDKAuth
import Foundation
import KakaoSDKUser
import Alamofire
import OSLog

final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isNewUser = false
    @Published var loginError: String?
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "PhonesonalTrainer", category: "KakaoAuth")

    func loginWithKakao() {
        logger.info("[Kakao] 로그인 시작")
        if UserApi.isKakaoTalkLoginAvailable() {
            logger.info("[Kakao] 카카오톡 앱 로그인 가능 → KakaoTalk 로그인 시도")
            // ✅ 카카오톡 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken: OAuthToken?, error: Error?) in
                guard let self = self else { return }
                if let error = error {
                    self.logger.error("[Kakao] KakaoTalk 로그인 실패: \(error.localizedDescription, privacy: .public)")
                    // KakaoTalk 실패 시 계정 로그인으로 폴백 시도 (메인 스레드에서 보장)
                    DispatchQueue.main.async {
                        self.logger.info("[Kakao] KakaoTalk 실패 → KakaoAccount 폴백 시작")
                        self.loginWithKakaoAccountFallback()
                    }
                    return
                }

                if let token = oauthToken?.accessToken {
                    self.logger.info("[Kakao] KakaoTalk 로그인 성공 · 토큰 수신(앱 복귀 완료)")
                    self.fetchKakaoUserInfo(accessToken: token)
                } else {
                    self.logger.warning("[Kakao] KakaoTalk 로그인 성공 콜백이나 토큰이 비어있음 → TokenManager에서 재시도")
                    self.fetchKakaoUserInfo(accessToken: nil)
                }
            }
        } else {
            logger.info("[Kakao] 카카오톡 미설치/불가 → KakaoAccount 로그인 시도")
            // ✅ 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken: OAuthToken?, error: Error?) in
                guard let self = self else { return }
                if let error = error {
                    self.logger.error("[Kakao] KakaoAccount 로그인 실패: \(error.localizedDescription, privacy: .public)")
                    self.loginError = "KakaoAccount 로그인 실패: \(error.localizedDescription)"
                    return
                }

                if let token = oauthToken?.accessToken {
                    self.logger.info("[Kakao] KakaoAccount 로그인 성공 · 토큰 수신")
                    self.fetchKakaoUserInfo(accessToken: token)
                } else {
                    self.logger.warning("[Kakao] KakaoAccount 로그인 성공 콜백이나 토큰이 비어있음 → TokenManager에서 재시도")
                    self.fetchKakaoUserInfo(accessToken: nil)
                }
            }
        }
    }

    private func loginWithKakaoAccountFallback() {
        // 카카오톡 로그인 취소 시 계정 로그인으로 폴백
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken: OAuthToken?, error: Error?) in
            guard let self = self else { return }
            if let error = error {
                self.logger.error("[Kakao] 폴백(KakaoAccount) 로그인 실패: \(error.localizedDescription, privacy: .public)")
                self.loginError = "KakaoAccount 로그인 실패: \(error.localizedDescription)"
                return
            }

            if let token = oauthToken?.accessToken {
                self.logger.info("[Kakao] 폴백(KakaoAccount) 로그인 성공 · 토큰 수신")
                self.fetchKakaoUserInfo(accessToken: token)
            } else {
                self.logger.warning("[Kakao] 폴백 로그인 성공 콜백이나 토큰이 비어있음 → TokenManager에서 재시도")
                self.fetchKakaoUserInfo(accessToken: nil)
            }
        }
    }

    private func fetchKakaoUserInfo(accessToken: String?) {
        logger.info("[Kakao] 사용자 정보 조회 시작")
        UserApi.shared.me() { [weak self] user, error in
            if let error = error {
                self?.logger.error("[Kakao] 사용자 정보 조회 실패: \(error.localizedDescription, privacy: .public)")
                self?.loginError = "사용자 정보 조회 실패: \(error.localizedDescription)"
                return
            }

            guard let userId = user?.id else {
                self?.logger.error("[Kakao] 사용자 ID 없음")
                self?.loginError = "사용자 ID 없음"
                return
            }

            // ✅ accessToken 확보 (우선: 매개변수 → 보조: TokenManager)
            let tokenFromParam = accessToken
            let tokenFromManager = TokenManager.manager.getToken()?.accessToken
            guard let finalAccessToken = tokenFromParam ?? tokenFromManager else {
                self?.logger.error("[Kakao] AccessToken 없음 (param/TokenManager 모두 실패)")
                self?.loginError = "AccessToken 없음"
                return
            }

            self?.logger.info("[Kakao] 사용자 정보 조회 성공 · userId=\(userId) · 토큰 확보")

            // ✅ 백엔드로 accessToken 전송
            self?.sendCodeToServer(code: finalAccessToken)
        }
    }

    private func sendCodeToServer(code: String) {
        logger.info("[Kakao] 서버로 토큰 전송 시작")
        let url = "http://43.203.60.2:8080/auth/kakao/login"
        let parameters: [String: Any] = ["code": code]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: KakaoLoginResponse.self) { [weak self] response in
                switch response.result {
                case .success(let result):
                    self?.logger.info("[Kakao] 서버 응답 수신 성공 · isSuccess=\(result.isSuccess) · newUser=\(result.result.newUser)")
                    DispatchQueue.main.async {
                        self?.isLoggedIn = result.isSuccess
                        self?.isNewUser = result.result.newUser

                        // 필요 시 accessToken, tempToken 저장
                        let accessToken = result.result.accessToken
                        let tempToken = result.result.tempToken
                        self?.logger.info("[Kakao] 서버 토큰 수신 완료 · accessToken/ tempToken 존재 여부 저장 처리 예정")
                        // -> UserDefaults나 Keychain에 저장하거나 ViewModel에 전달
                    }
                case .failure(let error):
                    self?.logger.error("[Kakao] 서버 응답 오류: \(error.localizedDescription, privacy: .public)")
                    self?.loginError = "서버 응답 오류: \(error.localizedDescription)"
                }
            }
    }

    // MARK: - URL Open Handling (SwiftUI .onOpenURL에서 호출)
    @MainActor
    @discardableResult
    func handleOpenURL(_ url: URL) -> Bool {
        logger.info("[Kakao] onOpenURL 수신: \(url.absoluteString, privacy: .public)")
        if AuthApi.isKakaoTalkLoginUrl(url) {
            let handled = AuthController.handleOpenUrl(url: url)
            logger.info("[Kakao] AuthController.handleOpenUrl 처리 결과: \(handled)")
            return handled
        } else {
            logger.debug("[Kakao] 카카오톡 로그인 URL 아님 → 무시")
            return false
        }
    }
}

struct SimpleAuthResponse: Codable {
    let code: String
    let status: String
}
