import Foundation

enum ReportAPI {
    static let baseURL = URL(string: "http://43.203.60.2:8080")!

    static func getWeeklyReport(week: Int, accessToken: String?) -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent("/report/weight"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "week", value: String(week))]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = accessToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}


