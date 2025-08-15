//
//  MyPageAPI.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/15/25.
//

import Foundation

enum MyPageAPI {
    static let base = URL(string: "http://43.203.60.2:8080")!

    static func authedGET<T: Decodable>(_ path: String, as: T.Type) async throws -> T {
        guard let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty
        else { throw NSError(domain: "auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "로그인 필요(토큰 없음)"]) }

        var req = URLRequest(url: base.appendingPathComponent(path))
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, resp) = try await URLSession.shared.data(for: req)
        if let http = resp as? HTTPURLResponse,
           http.statusCode == 401 ||
           (http.value(forHTTPHeaderField: "Content-Type") ?? "").contains("text/html") {
            throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "인증 필요"])
        }

        let decoded = try JSONDecoder().decode(APIResponse<T>.self, from: data)
        guard decoded.isSuccess, let result = decoded.result
        else { throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: decoded.message ?? "서버 오류"]) }
        return result
    }

    static func fetchMyPageHome() async throws -> MyPageHomeDTO {
        try await authedGET("/mypage", as: MyPageHomeDTO.self)
    }

    static func fetchTarget() async throws -> TargetRecommendationDTO {
        try await authedGET("/mypage/target", as: TargetRecommendationDTO.self)
    }
}

