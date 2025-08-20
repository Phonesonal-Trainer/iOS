//
//  DietPlanAPI.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import Foundation

enum DietPlanAPI {
    private static let baseURL = "http://43.203.60.2:8080"
    
    static func generate(startDate: Date) async -> Bool {
        do {
            let df = DateFormatter()
            df.calendar = Calendar(identifier: .gregorian)
            df.locale = Locale(identifier: "ko_KR")
            df.timeZone = .current
            df.dateFormat = "yyyy-MM-dd"

            let body = GenerateDietPlanRequest(startDate: df.string(from: startDate))

            var req = URLRequest(url: URL(string: "http://43.203.60.2:8080/foods/plans/generate")!)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.addAuthToken()
            req.httpBody = try JSONEncoder().encode(body)

            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else { return false }
            // HTML 로그인 페이지가 오는 경우 가드
            if let ct = http.value(forHTTPHeaderField: "Content-Type"), ct.contains("text/html") {
                print("⚠️ 식단 플랜 응답이 HTML → 인증 필요 또는 잘못된 엔드포인트")
                return false
            }
            guard (200...299).contains(http.statusCode) else { return false }
            let decoded = try JSONDecoder().decode(GenerateDietPlanResponse.self, from: data)
            if decoded.isSuccess {
                // 프론트에서 “오늘 이전 요일 숨김” 기준으로 사용할 가시 시작일 저장
                DietPlanVisibility.visibleStartDate = startDate
            }
            return decoded.isSuccess
        } catch {
            print("❌ 식단 플랜 생성 실패:", error)
            return false
        }
    }
    
    // 새로운 식단 추천 생성 API
    static func generateDietRecommendation() async -> Bool {
        guard let url = URL(string: "\(baseURL)/foods/plans/generate") else {
            print("❌ 식단 추천 API URL 생성 실패")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Authorization 헤더 추가
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("🔑 식단 추천 API Authorization 헤더 추가")
        } else {
            print("⚠️ accessToken이 없어서 Authorization 헤더 미추가")
        }
        
        print("🚀 식단 추천 API 요청 시작")
        print("🚀 URL: \(url)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // HTTP 상태 코드 확인
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 400 {
                    print("❌ 식단 추천 API HTTP \(httpResponse.statusCode) 에러")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("📡 에러 응답: \(responseString)")
                    }
                    return false
                }
            }
            
            // 응답이 HTML인지 확인
            if let responseString = String(data: data, encoding: .utf8),
               responseString.trimmingCharacters(in: .whitespaces).hasPrefix("<") {
                print("⚠️ 식단 추천 API 응답이 HTML → 인증 문제")
                return false
            }
            
            // JSON 응답 파싱
            let dietResponse = try JSONDecoder().decode(DietRecommendationResponse.self, from: data)
            
            if dietResponse.isSuccess {
                print("✅ 식단 추천 API 성공: \(dietResponse.result)")
                return true
            } else {
                print("❌ 식단 추천 API 실패: \(dietResponse.message)")
                return false
            }
        } catch {
            print("❌ 식단 추천 API 에러: \(error)")
            return false
        }
    }
}

enum DietPlanVisibility {
    private static let key = "dietPlan_visibleStartDate"

    static var visibleStartDate: Date? {
        get {
            guard let s = UserDefaults.standard.string(forKey: key) else { return nil }
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df.date(from: s)
        }
        set {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            if let d = newValue {
                UserDefaults.standard.set(df.string(from: d), forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

    /// 목록 화면에서 해당 날짜의 식단 카드를 숨겨야 하는지 여부
    static func shouldHide(date: Date) -> Bool {
        guard let start = visibleStartDate else { return false }
        let cal = Calendar.current
        let lhs = cal.startOfDay(for: date)
        let rhs = cal.startOfDay(for: start)
        return lhs < rhs   // 시작일 이전은 숨김
    }
}

// 식단 추천 API 응답 모델
struct DietRecommendationResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}
