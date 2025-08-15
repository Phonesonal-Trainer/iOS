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
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // form data 생성
        var formData = URLComponents()
        formData.queryItems = [
            URLQueryItem(name: "tempToken", value: request.tempToken),
            URLQueryItem(name: "nickname", value: request.nickname),
            URLQueryItem(name: "age", value: String(request.age)),
            URLQueryItem(name: "gender", value: request.gender),
            URLQueryItem(name: "purpose", value: request.purpose),
            URLQueryItem(name: "deadline", value: String(request.deadline)),
            URLQueryItem(name: "height", value: String(request.height)),
            URLQueryItem(name: "weight", value: String(request.weight))
        ]
        
        if let bodyFatRate = request.bodyFatRate {
            formData.queryItems?.append(URLQueryItem(name: "bodyFatRate", value: String(bodyFatRate)))
        }
        
        if let muscleMass = request.muscleMass {
            formData.queryItems?.append(URLQueryItem(name: "muscleMass", value: String(muscleMass)))
        }
        
        urlRequest.httpBody = formData.query?.data(using: .utf8)
        
        // 디버깅을 위한 로깅
        print("🚀 Signup Request URL: \(url)")
        print("🚀 HTTP Method: \(urlRequest.httpMethod ?? "Unknown")")
        print("🚀 Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
        if let bodyString = formData.query {
            print("🚀 Signup Request Body: \(bodyString)")
        }
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
