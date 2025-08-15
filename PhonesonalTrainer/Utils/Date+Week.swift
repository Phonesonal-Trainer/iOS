import Foundation

enum WeekRangeStyle {
    case yyMMdd
    case yyyyMMdd
}

extension Date {
    /// Returns Monday-based start and Sunday-based end of the week containing the date
    func weekBounds() -> (start: Date, end: Date) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2 // Monday
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? self
        return (startOfWeek, endOfWeek)
    }

    static func formattedWeekPeriod(from start: Date, to end: Date, style: WeekRangeStyle = .yyyyMMdd) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = style == .yyMMdd ? "yy.MM.dd" : "yyyy.MM.dd"
        return "\(formatter.string(from: start)) – \(formatter.string(from: end))"
    }
}

struct WeekCalculator {
    /// Simple relative week index based on a reference (0 = current week)
    static func relativeWeekIndex(from reference: Date = Date(), offset: Int = 0) -> Int {
        return offset
    }
}


