import Foundation

protocol ReportServicing {
    func fetchWeekly(week: Int) async throws -> ReportWeeklyEnvelope
}

struct ReportService: ReportServicing {
    let accessTokenProvider: () -> String?

    init(accessTokenProvider: @escaping () -> String? = { UserDefaults.standard.string(forKey: "accessToken") }) {
        self.accessTokenProvider = accessTokenProvider
    }

    func fetchWeekly(week: Int) async throws -> ReportWeeklyEnvelope {
        let request = ReportAPI.getWeeklyReport(week: week, accessToken: accessTokenProvider())
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        if http.statusCode == 401 { throw URLError(.userAuthenticationRequired) }
        guard (200...299).contains(http.statusCode) else { throw URLError(.badServerResponse) }
        return try JSONDecoder().decode(ReportWeeklyEnvelope.self, from: data)
    }
}


