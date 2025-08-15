import Foundation

protocol ReportRepositorying {
    var useMock: Bool { get set }
    func fetchWeekly(week: Int) async throws -> ReportWeekly
}

final class ReportRepository: ReportRepositorying {
    var useMock: Bool
    private let service: ReportServicing

    init(service: ReportServicing = ReportService(), useMock: Bool = true) {
        self.service = service
        self.useMock = useMock
    }

    func fetchWeekly(week: Int) async throws -> ReportWeekly {
        if useMock {
            return ReportPreviewData.mockAllFilled.weekly
        }
        let envelope = try await service.fetchWeekly(week: week)
        return ReportWeekly.fromResponse(envelope.result)
    }
}


