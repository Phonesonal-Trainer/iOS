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
    
    private let baseURL = "http://43.203.60.2:8080"
    
    func signup(request: SignupRequest) -> AnyPublisher<SignupResponse, Error> {
        guard let url = URL(string: "\(baseURL)/auth/signup") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON 데이터 생성
        var jsonBody: [String: Any] = [
            "tempToken": request.tempToken,
            "nickname": request.nickname,
            "age": request.age,
            "gender": request.gender,
            "purpose": request.purpose,
            "deadline": request.deadline,
            "height": request.height,
            "weight": request.weight
        ]
        
        // 옵셔널 필드 추가
        if let bodyFatRate = request.bodyFatRate {
            jsonBody["bodyFatRate"] = bodyFatRate
        }
        
        if let muscleMass = request.muscleMass {
            jsonBody["muscleMass"] = muscleMass
        }
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        // 디버깅을 위한 로깅
        print("🚀 Signup Request URL: \(url)")
        print("🚀 HTTP Method: \(urlRequest.httpMethod ?? "Unknown")")
        print("🚀 Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        print("🚀 JSON Body: \(jsonBody)")
        if let bodyData = urlRequest.httpBody {
            print("🚀 Body Data Size: \(bodyData.count) bytes")
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                // HTTP 응답 상태 코드 확인
                if let httpResponse = output.response as? HTTPURLResponse {
                    print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                    print("📡 Response Headers: \(httpResponse.allHeaderFields)")
                    
                    // 응답 데이터 로깅 (상태코드와 상관없이)
                    if let responseString = String(data: output.data, encoding: .utf8) {
                        print("📡 API Response Body: \(responseString)")
                        print("📡 Response Length: \(responseString.count) characters")
                        
                        // JSON인지 HTML인지 확인
                        if responseString.trimmingCharacters(in: .whitespaces).hasPrefix("{") {
                            print("📡 Response Format: JSON ✅")
                        } else if responseString.trimmingCharacters(in: .whitespaces).hasPrefix("<") {
                            print("📡 Response Format: HTML ❌")
                        } else {
                            print("📡 Response Format: Unknown")
                        }
                    } else {
                        print("📡 API Response: [No readable content]")
                    }
                    
                    // 4xx, 5xx 에러 상태 코드 처리
                    if httpResponse.statusCode >= 400 {
                        let errorMessage = String(data: output.data, encoding: .utf8) ?? "Server Error"
                        throw NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: [
                            NSLocalizedDescriptionKey: "서버 오류가 발생했습니다. (코드: \(httpResponse.statusCode))"
                        ])
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
}
