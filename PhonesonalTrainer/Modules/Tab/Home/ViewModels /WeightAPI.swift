import Foundation

// 공용 응답 래퍼는 'APIResponse.swift'에 1개만 있어야 함
// struct ApiResponse<T: Decodable> { ... }  ← 중복 선언 금지!

// GET 응답 result
struct WeightResultDTO: Decodable {
    let weight: Double
    let recordDate: String
}

// POST 요청 바디
struct WeightRecordBody: Encodable {
    let weight: Double
    let recordDate: String  // ISO8601 with milliseconds + 'Z'
}

enum WeightAPI {
    // 👇 네 환경에 맞게 교체
    private static let base = "http://43.203.60.2:8080"
    private static func url(_ path: String) -> URL { URL(string: base + path)! }

    // GET /home/{userId}/main/get-weight-record
    static func fetchCurrent(userId: Int) async throws -> Double {
        var req = URLRequest(url: url("/home/\(userId)/main/get-weight-record"))
        req.httpMethod = "GET"
        req.addAuthToken()
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: req)
        
        // HTTP 상태 코드 확인
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode >= 400 {
                // 에러 응답인 경우에도 JSON 파싱 시도하여 에러 메시지 추출
                if let errorMsg = try? JSONDecoder().decode(APIResponse<String>.self, from: data) {
                    throw NSError(domain: "WeightAPI", code: httpResponse.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: errorMsg.message ?? "서버 에러"])
                } else {
                    throw NSError(domain: "WeightAPI", code: httpResponse.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode) 에러"])
                }
            }
        }
        
        let decoded = try JSONDecoder().decode(APIResponse<WeightResultDTO>.self, from: data)
        guard decoded.isSuccess, let w = decoded.result?.weight else {
            throw NSError(domain: "WeightAPI", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: decoded.message ?? "몸무게 조회 실패"])
        }
        return w
    }

    // POST /home/{userId}/main/post-weight-record
    static func update(userId: Int, weight: Double, at date: Date = Date()) async throws {
        var req = URLRequest(url: url("/home/\(userId)/main/post-weight-record"))
        req.httpMethod = "POST"
        req.addAuthToken()
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        // ISO8601(밀리초 + Z) 포맷: 예) 2025-08-14T16:06:43.413Z
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        iso.timeZone = TimeZone(secondsFromGMT: 0)

        let body = WeightRecordBody(weight: weight, recordDate: iso.string(from: date))
        req.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: req)
        
        // HTTP 상태 코드 확인
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode >= 400 {
                // 에러 응답인 경우에도 JSON 파싱 시도하여 에러 메시지 추출
                if let errorMsg = try? JSONDecoder().decode(APIResponse<String>.self, from: data) {
                    throw NSError(domain: "WeightAPI", code: httpResponse.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: errorMsg.message ?? "서버 에러"])
                } else {
                    throw NSError(domain: "WeightAPI", code: httpResponse.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode) 에러"])
                }
            }
        }
        
        let decoded = try JSONDecoder().decode(APIResponse<String>.self, from: data) // 스웨거 Example이 result: "string"
        guard decoded.isSuccess else {
            throw NSError(domain: "WeightAPI", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: decoded.message ?? "몸무게 저장 실패"])
        }
    }
}
