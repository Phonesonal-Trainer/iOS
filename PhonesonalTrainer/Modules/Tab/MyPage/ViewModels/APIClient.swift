// APIClient.swift
import Foundation

// 공통 응답 래퍼
struct APIResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: String?
    let message: String?
    let result: T?
}

// 에러 정의
enum APIError: Error, LocalizedError {
    case invalidURL
    case noToken
    case http(Int)
    case server(String)
    case decode
    case requiresLogin
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "잘못된 URL"
        case .noToken: return "로그인이 필요합니다 (토큰 없음)"
        case .http(let s): return "HTTP 오류: \(s)"
        case .server(let msg): return msg
        case .decode: return "응답 파싱 실패"
        case .requiresLogin: return "로그인이 필요합니다"
        case .unknown: return "알 수 없는 오류"
        }
    }
}




final class APIClient {
    static let shared = APIClient()
    private let baseURL = URL(string: "http://43.203.60.2:8080")!
    private let session = URLSession(configuration: .default)

    // PATCH (닉네임/신장 변경)
    func patch<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]
    ) async throws -> APIResponse<T> {
        guard var comps = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        comps.queryItems = queryItems
        guard let url = comps.url else { throw APIError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = "PATCH"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.addAuthToken()

        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.unknown }
        guard (200..<300).contains(http.statusCode) else { throw APIError.http(http.statusCode) }

        do { return try JSONDecoder().decode(APIResponse<T>.self, from: data) }
        catch { throw APIError.decode }
    }

    // GET (프로필 조회)
    func get<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> APIResponse<T> {
        guard var comps = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        comps.queryItems = queryItems
        guard let url = comps.url else { throw APIError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.addAuthToken()

        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.unknown }

        // 스웨거가 로그인 HTML을 200으로 줄 수도 있어 방지
        if let ct = http.value(forHTTPHeaderField: "Content-Type"),
           ct.contains("text/html") {
            throw APIError.requiresLogin
        }
        guard (200..<300).contains(http.statusCode) else { throw APIError.http(http.statusCode) }

        do { return try JSONDecoder().decode(APIResponse<T>.self, from: data) }
        catch { throw APIError.decode }
    }
}
