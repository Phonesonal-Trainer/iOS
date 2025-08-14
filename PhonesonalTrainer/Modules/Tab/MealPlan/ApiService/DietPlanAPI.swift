//
//  DietPlanAPI.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import Foundation

enum DietPlanAPI {
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
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return false }
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
