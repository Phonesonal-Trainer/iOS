import Foundation

struct ReportPreviewData {
    let weekly: ReportWeekly

    static let mockAllFilled = ReportPreviewData(weekly: ReportWeekly(
        week: 3,
        weekStart: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
        weekEnd: Date(),
        feedbackExist: true,
        dailyWeights: [
            .monday: 52.0,
            .tuesday: 51.8,
            .wednesday: 51.6,
            .thursday: 51.5,
            .friday: 51.6,
            .saturday: 51.5,
            .sunday: 51.4
        ],
        changeFromTarget: 3.2,
        changeFromInitial: -1.4
    ))

    static let mockSomeMissing = ReportPreviewData(weekly: ReportWeekly(
        week: 4,
        weekStart: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
        weekEnd: Date(),
        feedbackExist: false,
        dailyWeights: [
            .monday: 52.0,
            .tuesday: nil,
            .wednesday: 51.8,
            .thursday: 51.5,
            .friday: 51.6,
            .saturday: nil,
            .sunday: 51.4
        ],
        changeFromTarget: -0.8,
        changeFromInitial: 0.4
    ))

    static let mockAllMissing = ReportPreviewData(weekly: ReportWeekly(
        week: 5,
        weekStart: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
        weekEnd: Date(),
        feedbackExist: false,
        dailyWeights: Dictionary(uniqueKeysWithValues: DayOfWeek.ordered.map { ($0, nil as Double?) }),
        changeFromTarget: nil,
        changeFromInitial: nil
    ))
}

extension ReportViewModel {
    @MainActor
    static var preview: ReportViewModel {
        let repo = ReportRepository()
        let vm = ReportViewModel(repository: repo)
        let mock = ReportPreviewData.mockAllFilled.weekly
        vm.currentWeek = mock.week
        vm.feedbackExist = mock.feedbackExist
        vm.dailyWeights = mock.dailyWeights
        vm.changeFromTarget = mock.changeFromTarget
        vm.changeFromInitial = mock.changeFromInitial
        vm.periodText = Date.formattedWeekPeriod(from: mock.weekStart, to: mock.weekEnd)
        return vm
    }
}


