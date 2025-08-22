//
//  HomeAPI.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/15/25.
//

import Foundation

enum API {
    static let baseURL = URL(string: "http://43.203.60.2:8080")!
}

enum HomeAPI {
    static func fetchHomeMain(userId: Int) async throws -> HomeMainResponse {
        return try await fetchHomeMainWithRetry(userId: userId, retryCount: 1)
    }
    
    private static func fetchHomeMainWithRetry(userId: Int, retryCount: Int) async throws -> HomeMainResponse {
        let url = API.baseURL.appendingPathComponent("/home/\(userId)/main")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.addAuthToken() // 토큰 필수

        let (data, resp) = try await URLSession.shared.data(for: req)
        
        // HTTP 상태 코드 확인 및 상세 에러 처리
        if let http = resp as? HTTPURLResponse {
            if !(200...299).contains(http.statusCode) {
                let body = String(data: data, encoding: .utf8) ?? ""
                print("❌ /home/{userId}/main HTTP \(http.statusCode)\n\(body)")
                
                // 401/403 에러인 경우 토큰 갱신 시도
                if (http.statusCode == 401 || http.statusCode == 403) && retryCount > 0 {
                    print("🔄 인증 에러 발생 - 토큰 갱신 시도")
                    if await AuthAPI.refreshToken() {
                        print("🔄 토큰 갱신 성공 - 재시도")
                        return try await fetchHomeMainWithRetry(userId: userId, retryCount: retryCount - 1)
                    } else {
                        print("❌ 토큰 갱신 실패 - 재로그인 필요")
                        // 토큰 클리어
                        UserDefaults.standard.removeObject(forKey: "accessToken")
                        UserDefaults.standard.removeObject(forKey: "refreshToken")
                        UserDefaults.standard.removeObject(forKey: "authToken")
                        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                        throw NSError(domain: "HomeAPI", code: 401,
                                      userInfo: [NSLocalizedDescriptionKey: "인증이 만료되었습니다. 다시 로그인해주세요."])
                    }
                }
                
                // 500 에러인 경우 더 자세한 로그
                if http.statusCode == 500 {
                    print("🔍 500 에러 상세: userDetails null 문제로 추정")
                    // 500 에러의 경우 특별 처리 - 빈 데이터로 반환하여 앱 크래시 방지
                    if let errorResponse = try? JSONDecoder().decode(APIResponse<String>.self, from: data) {
                        print("📡 500 에러 메시지: \(errorResponse.message ?? "알 수 없는 오류")")
                        // 운동 데이터가 없는 경우 빈 데이터로 처리
                        if errorResponse.message?.contains("등록된 운동이 없습니다") == true {
                            throw NSError(domain: "HomeAPI", code: 500,
                                          userInfo: [NSLocalizedDescriptionKey: "오늘 등록된 운동이 없습니다. 운동을 추가해보세요!"])
                        }
                    }
                }
                
                // 에러 응답을 JSON으로 파싱 시도
                if let errorResponse = try? JSONDecoder().decode(APIResponse<String>.self, from: data) {
                    throw NSError(domain: "HomeAPI", code: http.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: errorResponse.message ?? "서버 에러"])
                } else {
                    throw NSError(domain: "HomeAPI", code: http.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode) 에러"])
                }
            }
        }
        
        // JSON 파싱 에러 처리
        do {
            return try JSONDecoder().decode(HomeMainResponse.self, from: data)
        } catch {
            print("❌ 홈 API JSON 파싱 실패: \(error)")
            print("📄 응답 데이터: \(String(data: data, encoding: .utf8) ?? "인코딩 실패")")
            print("🔄 더미 데이터로 대체")
            
            // 더미 데이터로 대체
            return HomeMainResponse(
                isSuccess: true,
                code: "DUMMY200",
                message: "더미 데이터",
                result: DummyData.homeMainResult
            )
        }
    }
}
