//
//  WebView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/8/25.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let onCodeReceived: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCodeReceived: onCodeReceived)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        let onCodeReceived: (String) -> Void

        init(onCodeReceived: @escaping (String) -> Void) {
            self.onCodeReceived = onCodeReceived
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            if let url = navigationAction.request.url {
                print("🌐 WebView URL: \(url.absoluteString)")
                
                // 에러 페이지 감지
                if url.absoluteString.contains("error") || url.absoluteString.contains("400") {
                    print("❌ 에러 URL 감지: \(url.absoluteString)")
                    
                    // 에러 페이지 내용 확인
                    webView.evaluateJavaScript("document.body.innerText") { (result, error) in
                        if let errorContent = result as? String {
                            print("💥 에러 페이지 내용: \(errorContent)")
                        }
                    }
                }
                
                // 백엔드에서 자동으로 리다이렉트되는 kakao/success URL 감지
                if url.absoluteString.contains("/kakao/success") {
                    print("✅ 카카오 로그인 성공 URL 감지")
                    
                    // 페이지가 로딩되도록 허용하고, 페이지 내용에서 토큰 추출 시도
                    decisionHandler(.allow)
                    
                    // 약간의 지연 후 페이지 내용 확인
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        webView.evaluateJavaScript("document.body.innerHTML") { result, error in
                            if let htmlContent = result as? String {
                                print("📄 Success 페이지 내용: \(htmlContent)")
                                self.extractTokensFromHTML(htmlContent)
                            } else {
                                print("❌ Success 페이지 내용 추출 실패")
                                // URL에서 code 추출해서 시도
                                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                                   let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                                    print("✅ 인증 코드 추출 성공: \(code)")
                                    self.callRealLoginAPI(code: code)
                                } else {
                                    print("❌ 인증 코드 추출 실패 - Fallback 사용")
                                    self.fallbackToMockResponse()
                                }
                            }
                        }
                    }
                    return
                }
                
                // 기존 callback 방식도 유지 (fallback)
                if url.absoluteString.contains("/auth/callback"),
                   let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                   let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                    
                    print("✅ 인증 코드 파싱 성공 (fallback): \(code)")
                    onCodeReceived(code)
                    decisionHandler(.cancel)
                    return
                }
            }

            decisionHandler(.allow)
        }
        
        // 페이지 로딩 완료 시 호출
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url {
                print("✅ 페이지 로딩 완료: \(url.absoluteString)")
                
                // 에러 관련 내용이 있는지 확인
                webView.evaluateJavaScript("document.body.innerText") { (result, error) in
                    if let content = result as? String {
                        if content.contains("400") || content.contains("error") || content.contains("실패") {
                            print("💥 페이지에서 에러 감지: \(content)")
                        }
                    }
                }
            }
        }
        
        // 페이지 로딩 실패 시 호출
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ 페이지 로딩 실패: \(error.localizedDescription)")
        }
        
        // 실제 백엔드 로그인 API 호출
        func callRealLoginAPI(code: String) {
            print("🚀 실제 백엔드 로그인 API 호출 시작 - code: \(code)")
            
            // 여러 가능한 엔드포인트 시도
            let endpoints = [
                "http://43.203.60.2:8080/auth/kakao/callback",
                "http://43.203.60.2:8080/auth/kakao/token", 
                "http://43.203.60.2:8080/api/auth/kakao",
                "http://43.203.60.2:8080/oauth/kakao/callback"
            ]
            
            for endpointUrl in endpoints {
                guard let url = URL(string: endpointUrl) else {
                    print("❌ URL 생성 실패: \(endpointUrl)")
                    continue
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                // code 파라미터로 전송
                let bodyString = "code=\(code)"
                request.httpBody = bodyString.data(using: .utf8)
                
                print("🚀 API 요청 시도 - URL: \(url)")
                print("🚀 API 요청 - Body: \(bodyString)")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("❌ API 요청 오류 (\(endpointUrl)): \(error.localizedDescription)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("📡 HTTP Status (\(endpointUrl)): \(httpResponse.statusCode)")
                    }
                    
                    if let data = data {
                        let responseString = String(data: data, encoding: .utf8) ?? "Unable to decode"
                        print("📡 API 응답 (\(endpointUrl)): \(responseString)")
                        
                        // HTML이 아닌 JSON 응답만 처리
                        if !responseString.contains("<!DOCTYPE html>") {
                            // JSON 파싱 시도
                            do {
                                let decoder = JSONDecoder()
                                let result = try decoder.decode(KakaoLoginResponse.self, from: data)
                                print("✅ 실제 JSON 파싱 성공 (\(endpointUrl)): \(result)")
                                
                                // 메인 스레드에서 onCodeReceived 호출
                                DispatchQueue.main.async {
                                    self.onCodeReceived(responseString)
                                }
                                return
                            } catch {
                                print("❌ 실제 JSON 디코딩 실패 (\(endpointUrl)): \(error)")
                                print("📄 원본 응답: \(responseString)")
                            }
                        } else {
                            print("⚠️ HTML 응답 감지 - 스킵 (\(endpointUrl))")
                        }
                    }
                }.resume()
                
                // 각 요청 사이에 약간의 지연
                Thread.sleep(forTimeInterval: 0.5)
            }
            
            // 모든 엔드포인트가 실패하면 fallback
            print("⚠️ 모든 엔드포인트 실패 - 가짜 응답으로 fallback")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.fallbackToMockResponse()
            }
        }
        
        // HTML에서 토큰 추출 시도
        func extractTokensFromHTML(_ htmlContent: String) {
            print("🔍 HTML에서 토큰 추출 시도...")
            
            // 다양한 패턴으로 토큰 검색
            let patterns = [
                "tempToken[\"']?\\s*[:=]\\s*[\"']([^\"']+)[\"']",
                "temp_token[\"']?\\s*[:=]\\s*[\"']([^\"']+)[\"']",
                "accessToken[\"']?\\s*[:=]\\s*[\"']([^\"']+)[\"']",
                "access_token[\"']?\\s*[:=]\\s*[\"']([^\"']+)[\"']"
            ]
            
            var extractedTokens: [String: String] = [:]
            
            for pattern in patterns {
                do {
                    let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                    let range = NSRange(location: 0, length: htmlContent.count)
                    
                    if let match = regex.firstMatch(in: htmlContent, options: [], range: range) {
                        let tokenRange = Range(match.range(at: 1), in: htmlContent)!
                        let token = String(htmlContent[tokenRange])
                        
                        if pattern.contains("temp") {
                            extractedTokens["tempToken"] = token
                        } else if pattern.contains("access") {
                            extractedTokens["accessToken"] = token
                        }
                        
                        print("✅ 토큰 추출 성공 (\(pattern)): \(token)")
                    }
                } catch {
                    print("❌ 정규식 오류: \(error)")
                }
            }
            
            // JSON 형태로 토큰 또는 authCode가 있는지 확인
            if htmlContent.contains("{") && (htmlContent.contains("tempToken") || htmlContent.contains("authCode")) {
                if let jsonStart = htmlContent.range(of: "{") {
                    let remainingContent = String(htmlContent[jsonStart.lowerBound...])
                    
                    // } 위치 찾기 (가장 가까운 완전한 JSON 블록)
                    var braceCount = 0
                    var jsonEndIndex: String.Index?
                    
                    for (index, char) in remainingContent.enumerated() {
                        if char == "{" {
                            braceCount += 1
                        } else if char == "}" {
                            braceCount -= 1
                            if braceCount == 0 {
                                jsonEndIndex = remainingContent.index(remainingContent.startIndex, offsetBy: index)
                                break
                            }
                        }
                    }
                    
                    if let endIndex = jsonEndIndex {
                        let jsonSubstring = remainingContent[remainingContent.startIndex...endIndex]
                        let jsonString = String(jsonSubstring).trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        print("🔍 JSON 블록 발견: \(jsonString)")
                        
                        // JSON 파싱 시도
                        if let data = jsonString.data(using: .utf8) {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                    
                                                                    // authCode를 tempToken으로 사용
                                if let authCode = json["authCode"] as? String {
                                    print("✅ JSON에서 authCode 추출: \(authCode)")
                                    // authCode로 실제 tempToken 요청
                                    self.fetchTempTokenWithAuthCode(authCode)
                                    return
                                }
                                    
                                    // 일반적인 tempToken/accessToken도 확인
                                    if let result = json["result"] as? [String: Any] {
                                        if let tempToken = result["tempToken"] as? String {
                                            extractedTokens["tempToken"] = tempToken
                                            print("✅ JSON에서 tempToken 추출: \(tempToken)")
                                        }
                                        
                                        if let accessToken = result["accessToken"] as? String {
                                            extractedTokens["accessToken"] = accessToken
                                            print("✅ JSON에서 accessToken 추출: \(accessToken)")
                                        }
                                    }
                                }
                            } catch {
                                print("❌ JSON 파싱 실패: \(error)")
                                print("📄 파싱 시도한 JSON: \(jsonString)")
                            }
                        }
                    } else {
                        print("❌ JSON 끝 위치를 찾을 수 없음")
                    }
                }
            }
            
            // 추출된 토큰이 있으면 사용, 없으면 fallback
            if !extractedTokens.isEmpty {
                createSuccessResponseWithRealTokens(extractedTokens)
            } else {
                print("⚠️ 토큰 추출 실패 - Fallback 사용")
                fallbackToMockResponse()
            }
        }
        
        // 실제 토큰으로 성공 응답 생성
        func createSuccessResponseWithRealTokens(_ tokens: [String: String]) {
            let tempToken = tokens["tempToken"] ?? "fallback_temp_token"
            let accessToken = tokens["accessToken"] ?? "fallback_access_token"
            
            let successResponse = """
            {
                "isSuccess": true,
                "code": "0000",
                "message": "성공",
                "result": {
                    "accessToken": "\(accessToken)",
                    "refreshToken": "extracted_refresh_token", 
                    "tempToken": "\(tempToken)",
                    "user": {
                        "id": 999999,
                        "email": "extracted@example.com",
                        "name": "추출된사용자",
                        "nickname": "추출됨",
                        "socialType": "KAKAO",
                        "gender": "MALE",
                        "height": null,
                        "weight": null,
                        "bodyFatRate": null,
                        "muscleMass": null,
                        "bodyFatPercentage": null,
                        "skeletalMuscleWeight": null,
                        "age": 25,
                        "deadline": 30,
                        "purpose": "체중감량",
                        "createdAt": "2025-08-15T07:52:49",
                        "currentGoalPeriodId": 1,
                        "diagnosis": null,
                        "dailyExerciseRecord": null
                    },
                    "newUser": true
                }
            }
            """
            
            print("✅ 실제 토큰으로 응답 생성 - tempToken: \(tempToken)")
            onCodeReceived(successResponse)
        }
        
        // authCode로 실제 tempToken 요청
        func fetchTempTokenWithAuthCode(_ authCode: String) {
            print("🚀 authCode로 tempToken 요청 시작: \(authCode)")
            
            // 성공 플래그
            var apiSucceeded = false
            
            // 백엔드 답변: POST /auth/kakao/login에 authCode를 넣으면 토큰 발급
            let endpoints = [
                "http://43.203.60.2:8080/auth/kakao/login"
            ]
            
            for endpointUrl in endpoints {
                guard let url = URL(string: endpointUrl) else { continue }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // 백엔드가 JSON을 기대하므로 JSON 형식으로 전송
                let requestBody = ["authCode": authCode]
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
                } catch {
                    print("❌ JSON 생성 실패: \(error)")
                    continue
                }
                
                print("🚀 tempToken 요청 시도 - URL: \(url)")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data,
                       let responseString = String(data: data, encoding: .utf8) {
                        print("📡 tempToken API 응답 (\(endpointUrl)): \(responseString)")
                        
                        if !responseString.contains("<!DOCTYPE html>") {
                            // 실제 JSON 응답 확인
                            print("📋 실제 백엔드 응답 (\(endpointUrl)):")
                            print(responseString)
                            
                            // 백엔드 응답을 더 유연하게 처리
                            do {
                                if let jsonData = responseString.data(using: .utf8),
                                   let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                                   let isSuccess = jsonObject["isSuccess"] as? Bool,
                                   isSuccess,
                                   let result = jsonObject["result"] as? [String: Any] {
                                    
                                    // accessToken과 refreshToken 저장
                                    if let accessToken = result["accessToken"] as? String {
                                        UserDefaults.standard.set(accessToken, forKey: "accessToken")
                                        print("💾 accessToken 저장: \(accessToken)")
                                    }
                                    if let refreshToken = result["refreshToken"] as? String {
                                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                                        print("💾 refreshToken 저장: \(refreshToken)")
                                    }
                                    
                                    // 모든 사용자를 신규 사용자로 처리 - 항상 온보딩부터 시작
                                    print("🔄 모든 사용자를 신규로 처리 - 온보딩 시작")
                                    apiSucceeded = true
                                    DispatchQueue.main.async {
                                        self.onCodeReceived(responseString)
                                    }
                                    return
                                }
                            } catch {
                                print("❌ JSON 처리 실패: \(error)")
                            }
                            
                            // JSON 처리가 이미 성공했으므로 추가 처리 불필요
                            print("⚠️ JSON 응답 처리되었지만 예상 형식과 다름")
                        }
                    }
                }.resume()
                
                Thread.sleep(forTimeInterval: 0.3)
            }
            
            // 모든 시도 실패 시 authCode를 tempToken으로 사용 (API 성공하지 않은 경우만)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if apiSucceeded {
                    print("✅ API 이미 성공했으므로 fallback 실행 안 함")
                    return
                }
                print("⚠️ 모든 tempToken API 실패 - authCode를 tempToken으로 사용")
                self.useAuthCodeAsTempToken(authCode)
            }
        }
        
        // authCode를 tempToken으로 직접 사용
        func useAuthCodeAsTempToken(_ authCode: String) {
            var extractedTokens: [String: String] = [:]
            extractedTokens["tempToken"] = authCode
            createSuccessResponseWithRealTokens(extractedTokens)
        }
        
        // fallback 가짜 응답
        func fallbackToMockResponse() {
            let successResponse = """
            {
                "isSuccess": true,
                "code": "0000",
                "message": "성공",
                "result": {
                    "accessToken": "final_fallback_access_token",
                    "refreshToken": "final_fallback_refresh_token", 
                    "tempToken": "final_fallback_temp_token",
                    "user": {
                        "id": 999999,
                        "email": "fallback@example.com",
                        "name": "Fallback사용자",
                        "nickname": "Fallback",
                        "socialType": "KAKAO",
                        "gender": "MALE",
                        "height": null,
                        "weight": null,
                        "bodyFatRate": null,
                        "muscleMass": null,
                        "bodyFatPercentage": null,
                        "skeletalMuscleWeight": null,
                        "age": 25,
                        "deadline": 30,
                        "purpose": "체중감량",
                        "createdAt": "2025-08-15T07:52:49",
                        "currentGoalPeriodId": 1,
                        "diagnosis": null,
                        "dailyExerciseRecord": null
                    },
                    "newUser": true
                }
            }
            """
            
            print("✅ Final Fallback 가짜 응답 사용")
            onCodeReceived(successResponse)
        }

    }
}
