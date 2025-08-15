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
        let mockAPIService = MockReportAPIService()
        let vm = ReportViewModel(apiService: mockAPIService)
        
        // 미리 Mock 데이터로 설정
        vm.weekTitle = "25.01.20 - 25.01.26"
        vm.changeFromTargetWeight = "+2.5kg"
        vm.changeFromInitialWeight = "-1.2kg"
        vm.exerciseTotalConsumedText = "1,670 / 1,750"
        vm.exerciseAverageDailyText = "238"
        vm.foodTotalConsumedText = "11,200 / 12,600"
        vm.foodAverageDailyText = "1,600"
        vm.dietStampMessage = "이번 주 식단 목표를 잘 달성했어요!"
        
        // Mock 막대 데이터
        vm.weightBars = [
            DayBar(day: "MONDAY", dayDisplay: "월", value: 70.5, target: 68.0, percent: 103.7, height: 0.8, color: .overYellow),
            DayBar(day: "TUESDAY", dayDisplay: "화", value: 70.2, target: 68.0, percent: 103.2, height: 0.7, color: .overYellow),
            DayBar(day: "WEDNESDAY", dayDisplay: "수", value: 70.8, target: 68.0, percent: 104.1, height: 0.9, color: .overYellow),
            DayBar(day: "THURSDAY", dayDisplay: "목", value: 70.3, target: 68.0, percent: 103.4, height: 0.75, color: .overYellow),
            DayBar(day: "FRIDAY", dayDisplay: "금", value: 70.1, target: 68.0, percent: 103.1, height: 0.65, color: .overYellow),
            DayBar(day: "SATURDAY", dayDisplay: "토", value: 69.9, target: 68.0, percent: 102.8, height: 0.6, color: .overYellow),
            DayBar(day: "SUNDAY", dayDisplay: "일", value: 70.0, target: 68.0, percent: 102.9, height: 0.65, color: .overYellow)
        ]
        
        vm.exerciseBars = [
            DayBar(day: "MONDAY", dayDisplay: "월", value: 250, target: 250, percent: 100.0, height: 0.8, color: .good),
            DayBar(day: "TUESDAY", dayDisplay: "화", value: 180, target: 250, percent: 72.0, height: 0.6, color: .underYellow),
            DayBar(day: "WEDNESDAY", dayDisplay: "수", value: 320, target: 250, percent: 128.0, height: 1.0, color: .overYellow),
            DayBar(day: "THURSDAY", dayDisplay: "목", value: 290, target: 250, percent: 116.0, height: 0.9, color: .overYellow),
            DayBar(day: "FRIDAY", dayDisplay: "금", value: 200, target: 250, percent: 80.0, height: 0.65, color: .underYellow),
            DayBar(day: "SATURDAY", dayDisplay: "토", value: 150, target: 250, percent: 60.0, height: 0.5, color: .underYellow),
            DayBar(day: "SUNDAY", dayDisplay: "일", value: 280, target: 250, percent: 112.0, height: 0.85, color: .overYellow)
        ]
        
        vm.foodBars = [
            DayBar(day: "MONDAY", dayDisplay: "월", value: 1650, target: 1800, percent: 91.7, height: 0.8, color: .good),
            DayBar(day: "TUESDAY", dayDisplay: "화", value: 1450, target: 1800, percent: 80.6, height: 0.6, color: .underYellow),
            DayBar(day: "WEDNESDAY", dayDisplay: "수", value: 1720, target: 1800, percent: 95.6, height: 0.9, color: .good),
            DayBar(day: "THURSDAY", dayDisplay: "목", value: 1580, target: 1800, percent: 87.8, height: 0.7, color: .underYellow),
            DayBar(day: "FRIDAY", dayDisplay: "금", value: 1380, target: 1800, percent: 76.7, height: 0.55, color: .underYellow),
            DayBar(day: "SATURDAY", dayDisplay: "토", value: 1620, target: 1800, percent: 90.0, height: 0.75, color: .good),
            DayBar(day: "SUNDAY", dayDisplay: "일", value: 1800, target: 1800, percent: 100.0, height: 0.85, color: .good)
        ]
        
        return vm
    }
}


