import Foundation

struct ReportWeekly: Equatable {
    let week: Int
    let weekStart: Date
    let weekEnd: Date
    let feedbackExist: Bool
    let dailyWeights: [DayOfWeek: Double?]
    let changeFromTarget: Double?
    let changeFromInitial: Double?
}

extension ReportWeekly {
    static func fromResponse(_ dto: ReportWeeklyResponse) -> ReportWeekly {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"

        let start = formatter.date(from: dto.weekStart) ?? Date()
        let end = formatter.date(from: dto.weekEnd) ?? Date()

        var mapped: [DayOfWeek: Double?] = [:]
        for day in DayOfWeek.ordered {
            let raw = dto.dailyWeight[day.rawValue] ?? nil
            mapped[day] = raw
        }

        return ReportWeekly(
            week: dto.week,
            weekStart: start,
            weekEnd: end,
            feedbackExist: dto.feedbackExist,
            dailyWeights: mapped,
            changeFromTarget: dto.changeFromTargetWeight?.value,
            changeFromInitial: dto.changeFromInitialWeight?.value
        )
    }
}


