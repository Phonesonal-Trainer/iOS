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
        let url = API.baseURL.appendingPathComponent("/home/\(userId)/main")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.addAuthToken() // 토큰 필수

        let (data, resp) = try await URLSession.shared.data(for: req)
        if let http = resp as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? ""
            print("❌ /home/{userId}/main HTTP \(http.statusCode)\n\(body)")
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(HomeMainResponse.self, from: data)
    }
}
