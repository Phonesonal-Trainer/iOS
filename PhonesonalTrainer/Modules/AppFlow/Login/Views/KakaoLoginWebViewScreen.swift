//
//  KakaoLoginWebViewScreen.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/8/25.
//

import SwiftUI

struct KakaoLoginWebViewScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var showWebView = true
    @ObservedObject var authViewModel: AuthViewModel

    private let loginURL = URL(string: "http://43.203.60.2:8080/oauth2/authorization/kakao-prod")!
    
    init(authViewModel: AuthViewModel = AuthViewModel()) {
        self.authViewModel = authViewModel
    }

    var body: some View {
        VStack {
            if showWebView {
                WebView(url: loginURL) { responseData in
                    print("✅ 받은 데이터: \(responseData)")
                    
                    // 에러 메시지가 포함되어 있는지 확인
                    if responseData.contains("400") || responseData.contains("error") || responseData.contains("실패") {
                        print("💥 로그인 에러 감지: \(responseData)")
                        showWebView = false
                        // 에러 상황에서도 화면 닫기
                        DispatchQueue.main.async {
                            dismiss()
                        }
                        return
                    }
                    
                    showWebView = false
                    
                    // JSON 응답인지 확인하고 파싱 시도
                    if responseData.contains("{") && responseData.contains("}") {
                        // JSON 응답 처리
                        handleKakaoResponse(jsonString: responseData)
                    } else {
                        // 기존 방식: 인증 코드로 처리
                        sendCodeToServer(code: responseData)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    func sendCodeToServer(code: String) {
        guard let url = URL(string: "http://43.203.60.2:8080/auth/login/kakao") else {
            print("❌ 잘못된 URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = ["code": code]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("❌ JSON 직렬화 실패")
            return
        }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 요청 실패: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ 유효하지 않은 응답")
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(KakaoLoginResponse.self, from: data)
                        print("✅ 서버 응답: \(result)")
                        DispatchQueue.main.async {
                            // AuthViewModel 업데이트
                            self.authViewModel.isLoggedIn = result.isSuccess
                            self.authViewModel.isNewUser = result.result.newUser
                            self.authViewModel.tempToken = result.result.tempToken ?? ""
                            self.authViewModel.accessToken = result.result.accessToken
                            // 토큰/유저ID 저장 (전역)
                            UserDefaults.standard.set(result.result.accessToken, forKey: "accessToken")
                            UserDefaults.standard.set(result.result.accessToken, forKey: "authToken")
                            UserDefaults.standard.set(result.result.refreshToken, forKey: "refreshToken")
                            if let uid = result.result.user?.id { UserDefaults.standard.set(uid, forKey: "userId") }
                            dismiss()
                        }
                    } catch {
                        print("❌ 디코딩 실패: \(error)")
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("📄 서버 응답 내용: \(dataString)")
                        }
                    }
                }
            } else {
                print("❌ 서버 응답 코드 오류: \(httpResponse.statusCode)")
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("💥 에러 메시지: \(errorMessage)")
                }
            }
        }.resume()
    }
    
    func handleKakaoResponse(jsonString: String) {
        print("🔄 JSON 응답 처리 시작: \(jsonString)")
        
        guard let data = jsonString.data(using: .utf8) else {
            print("❌ JSON 문자열을 Data로 변환 실패")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(KakaoLoginResponse.self, from: data)
                                    print("✅ JSON 파싱 성공: \(result)")
            
            DispatchQueue.main.async {
                // AuthViewModel 업데이트
                self.authViewModel.isLoggedIn = result.isSuccess
                self.authViewModel.tempToken = result.result.tempToken ?? ""
                self.authViewModel.accessToken = result.result.accessToken
                
                // 기존 사용자 vs 신규 사용자 분기 (백엔드 newUser 플래그 기준)
                self.authViewModel.isNewUser = result.result.newUser
                // 토큰/유저ID 저장 (전역)
                UserDefaults.standard.set(result.result.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(result.result.accessToken, forKey: "authToken")
                UserDefaults.standard.set(result.result.refreshToken, forKey: "refreshToken")
                if let uid = result.result.user?.id { UserDefaults.standard.set(uid, forKey: "userId") }
                if result.result.newUser {
                    print("✅ 신규 사용자 로그인 완료 → 온보딩 이동")
                } else {
                    print("✅ 기존 사용자 로그인 완료 → 메인 화면 이동")
                }
                
                self.dismiss()
            }
        } catch {
            print("❌ JSON 디코딩 실패: \(error)")
            print("📄 원본 JSON: \(jsonString)")
            
            // 디코딩 실패 시에도 화면 닫기 (사용자 경험 개선)
            DispatchQueue.main.async {
                self.dismiss()
            }
        }
    }

}

#Preview{
    KakaoLoginWebViewScreen()
}
