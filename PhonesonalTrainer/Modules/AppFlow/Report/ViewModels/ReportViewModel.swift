import Foundation

@MainActor
final class ReportViewModel: ObservableObject {
    @Published var currentWeek: Int = 0
    @Published var periodText: String = ""
    @Published var feedbackExist: Bool = false
    @Published var dailyWeights: [DayOfWeek: Double?] = Dictionary(uniqueKeysWithValues: DayOfWeek.ordered.map { ($0, nil as Double?) })
    @Published var changeFromTarget: Double? = nil
    @Published var changeFromInitial: Double? = nil
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    @Published var hasSubmittedFeedback: Bool = false

    private let repository: ReportRepositorying

    init(repository: ReportRepositorying = ReportRepository()) {
        self.repository = repository
        self.currentWeek = 0
        computePeriod(for: Date())
    }

    func load(week: Int) async {
        isLoading = true
        error = nil
        do {
            let data = try await repository.fetchWeekly(week: week)
            apply(data)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func goPrevWeek() async { currentWeek -= 1; await load(week: currentWeek) }
    func goNextWeek() async { currentWeek += 1; await load(week: currentWeek) }
    func refresh() async { await load(week: currentWeek) }

    private func apply(_ weekly: ReportWeekly) {
        currentWeek = weekly.week
        dailyWeights = weekly.dailyWeights
        feedbackExist = weekly.feedbackExist && !hasSubmittedFeedback
        changeFromInitial = weekly.changeFromInitial
        changeFromTarget = weekly.changeFromTarget
        periodText = Date.formattedWeekPeriod(from: weekly.weekStart, to: weekly.weekEnd, style: .yyyyMMdd)
    }

    private func computePeriod(for date: Date) {
        let bounds = date.weekBounds()
        periodText = Date.formattedWeekPeriod(from: bounds.start, to: bounds.end, style: .yyyyMMdd)
    }
}


