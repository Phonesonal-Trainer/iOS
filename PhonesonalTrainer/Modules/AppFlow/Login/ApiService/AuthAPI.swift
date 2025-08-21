//
//  AuthAPI.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/25/25.
//

import Foundation
import Combine

class AuthAPI {
    static let shared = AuthAPI()
    private init() {}
    
    private func formURLEncodedData(_ params: [String: String]) -> Data {
        // RFC 3986 기준으로 &,=,+ 는 반드시 이스케이프
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "+&=")

        let pairs = params.map { key, value -> String in
            let k = key.addingPercentEncoding(withAllowedCharacters: allowed) ?? key
            let v = value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
            return "\(k)=\(v)"
        }
        return Data(pairs.joined(separator: "&").utf8)
    }
    
    private let baseURL = "http://43.203.60.2:8080"
    
    func signup(request: SignupRequest) -> AnyPublisher<SignupResponse, Error> {
        // URL에 tempToken을 query parameter로 추가
        var urlComponents = URLComponents(string: "\(baseURL)/auth/signup")!
        urlComponents.queryItems = [
            URLQueryItem(name: "tempToken", value: request.tempToken)
        ]
        
        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        // ✅ JSON 아님! 폼 파라미터로 보냄
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8",
                                forHTTPHeaderField: "Content-Type")

            // 폼 파라미터 구성
            var params: [String: String] = [
                "nickname": request.nickname,
                "age": String(request.age),
                "gender": request.gender,      // "FEMALE"
                "purpose": request.purpose,    // 서버 enum이면 매핑 필요: 예) "BULK_UP"
                "deadline": String(request.deadline),
                "height": String(request.height),
                "weight": String(request.weight)
            ]
            if let v = request.bodyFatRate { params["bodyFatRate"] = String(v) }
            if let v = request.muscleMass { params["muscleMass"] = String(v) }

            urlRequest.httpBody = formURLEncodedData(params)

        
        // 디버깅을 위한 로깅
        print("🚀 Signup Request URL: \(url)")
        print("🚀 HTTP Method: \(urlRequest.httpMethod ?? "Unknown")")
        print("🚀 Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        print("🚀 Query Parameters: tempToken=\(request.tempToken)")
        print("🚀 Form Body: \(params)")
        if let bodyData = urlRequest.httpBody {
            print("🚀 Body Data Size: \(bodyData.count) bytes")
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                // HTTP 응답 상태 코드 확인
                if let http = output.response as? HTTPURLResponse {
                    print("📡 HTTP Status Code: \(http.statusCode)")
                    print("📡 Response Headers: \(http.allHeaderFields)")
                    
                    let respStr = String(data: output.data, encoding: .utf8) ?? ""
                                    print("📡 API Response Body: \(respStr)")
                                    if http.statusCode >= 400 {
                                        // problem+json의 detail을 에러 메시지에 반영
                                        if let obj = try? JSONSerialization.jsonObject(with: output.data) as? [String: Any],
                                           let detail = obj["detail"] as? String {
                                            throw NSError(domain: "ServerError", code: http.statusCode,
                                                          userInfo: [NSLocalizedDescriptionKey: detail])
                                        }
                                        throw NSError(domain: "ServerError", code: http.statusCode,
                                                      userInfo: [NSLocalizedDescriptionKey: "서버 오류가 발생했습니다. (코드: \(http.statusCode))"])
                                    }
                } else {
                    print("📡 No HTTP Response received")
                }
                
                return output.data
            }
            .decode(type: SignupResponse.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<SignupResponse, Error> in
                print("❌ Signup API Error: \(error)")
                
                // JSON 파싱 에러인 경우 더 자세한 정보 제공
                if let decodingError = error as? DecodingError {
                    print("❌ JSON Decoding Error Details:")
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("❌ Data corrupted: \(context.debugDescription)")
                        print("❌ Coding path: \(context.codingPath)")
                    case .keyNotFound(let key, let context):
                        print("❌ Key '\(key)' not found: \(context.debugDescription)")
                        print("❌ Coding path: \(context.codingPath)")
                    case .typeMismatch(let type, let context):
                        print("❌ Type '\(type)' mismatch: \(context.debugDescription)")
                        print("❌ Coding path: \(context.codingPath)")
                    case .valueNotFound(let value, let context):
                        print("❌ Value '\(value)' not found: \(context.debugDescription)")
                        print("❌ Coding path: \(context.codingPath)")
                    @unknown default:
                        print("❌ Unknown decoding error")
                    }
                    
                    let customError = NSError(domain: "ParsingError", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "서버 응답을 해석할 수 없습니다. 잠시 후 다시 시도해주세요."
                    ])
                    return Fail(error: customError).eraseToAnyPublisher()
                }
                
                return Fail(error: error).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // 토큰 갱신 API
    static func refreshToken() async -> Bool {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),
              !refreshToken.isEmpty else {
            print("❌ refreshToken이 없어서 갱신 불가")
            return false
        }
        
        guard let url = URL(string: "http://43.203.60.2:8080/auth/refresh") else {
            print("❌ 토큰 갱신 API URL 생성 실패")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
        print("🔄 토큰 갱신 시도")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // 새로운 토큰 파싱
                    if let tokenResponse = try? JSONDecoder().decode(TokenRefreshResponse.self, from: data) {
                        if tokenResponse.isSuccess {
                            // 새로운 토큰 저장
                            UserDefaults.standard.set(tokenResponse.result.accessToken, forKey: "accessToken")
                            UserDefaults.standard.set(tokenResponse.result.refreshToken, forKey: "refreshToken")
                            print("✅ 토큰 갱신 성공")
                            return true
                        }
                    }
                } else {
                    print("❌ 토큰 갱신 실패: HTTP \(httpResponse.statusCode)")
                }
            }
        } catch {
            print("❌ 토큰 갱신 에러: \(error)")
        }
        
        return false
    }
}

// 토큰 갱신 응답 모델
struct TokenRefreshResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TokenRefreshResult
}

struct TokenRefreshResult: Codable {
    let accessToken: String
    let refreshToken: String
}
