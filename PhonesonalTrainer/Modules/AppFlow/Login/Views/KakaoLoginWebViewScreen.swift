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

    private let loginURL = URL(string: "http://43.203.60.2:8080/oauth2/authorization/kakao-prod")!

    var body: some View {
        VStack {
            if showWebView {
                WebView(url: loginURL) { code in
                    print("✅ 인증 코드: \(code)")
                    showWebView = false
                    // ✅ 인증 코드로 백엔드에 POST 요청 보내기
                    sendCodeToServer(code: code)
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
                            dismiss()
                        }
                    } catch {
                        print("❌ 디코딩 실패: \(error)")
                    }
                }
            } else {
                print("❌ 서버 응답 코드 오류: \(httpResponse.statusCode)")
            }
        }.resume()
    }

}
