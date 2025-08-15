// BodyPhotoAPI.swift
import Foundation

enum BodyPhotoAPI {
    static let base = "https://<YOUR_BASE_URL>" // ✅ 실제 베이스 URL

    static func fetchURL(userId: Int) async throws -> URL? {
        guard let url = URL(string: "\(base)/home/\(userId)/main/get-bodyphoto") else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addAuthToken() // 🔑 토큰 필요 시

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            print("❌ bodyphoto status:", (resp as? HTTPURLResponse)?.statusCode ?? -1)
            return nil
        }
        let decoded = try JSONDecoder().decode(APIResponse<BodyPhotoResultDTO>.self, from: data)
        guard decoded.isSuccess, let r = decoded.result else {
            print("❌ server msg:", decoded.message ?? "-")
            return nil
        }
        // 절대/상대 경로 둘 다 처리
        if let abs = URL(string: r.filePath), abs.scheme != nil {
            return abs
        } else {
            return URL(string: base + r.filePath)
        }
    }
}
