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

final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isNewUser = false
    @Published var loginError: String?

    func loginWithKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // ✅ 카카오톡 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                if let error = error {
                    self?.loginError = "KakaoTalk 로그인 실패: \(error.localizedDescription)"
                } else {
                    self?.fetchKakaoUserInfo()
                }
            }
        } else {
            // ✅ 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                if let error = error {
                    self?.loginError = "KakaoAccount 로그인 실패: \(error.localizedDescription)"
                } else {
                    self?.fetchKakaoUserInfo()
                }
            }
        }
    }

    private func fetchKakaoUserInfo() {
        UserApi.shared.me() { [weak self] user, error in
            if let error = error {
                self?.loginError = "사용자 정보 조회 실패: \(error.localizedDescription)"
                return
            }

            guard let userId = user?.id else {
                self?.loginError = "사용자 ID 없음"
                return
            }

            // ✅ accessToken 가져오기
            guard let accessToken = TokenManager.manager.getToken()?.accessToken else {
                self?.loginError = "AccessToken 없음"
                return
            }

            print("✅ 사용자 ID: \(userId), Token: \(accessToken)")

            // ✅ 백엔드로 accessToken 전송
            self?.sendCodeToServer(code: accessToken)
        }
    }

    private func sendCodeToServer(code: String) {
        let url = "http://43.203.60.2:8080/auth/kakao/login"
        let parameters: [String: Any] = ["code": code]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: SimpleAuthResponse.self) { [weak self] response in
                switch response.result {
                case .success(let result):
                    print("✅ 서버 응답: \(result.status)")
                    DispatchQueue.main.async {
                        self?.isLoggedIn = true
                        self?.isNewUser = result.status == "success"
                    }
                case .failure(let error):
                    self?.loginError = "서버 응답 오류: \(error.localizedDescription)"
                }
            }
    }
}

struct SimpleAuthResponse: Codable {
    let code: String
    let status: String
}
