import SwiftUI

struct ReportScreen: View {
    @StateObject var viewModel: ReportViewModel
    @State private var selectedTab: ReportTopTab = .all
    @State private var routePath: [ReportRoute] = []
    private let horizontalInset: CGFloat = 20

    init(viewModel: ReportViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $routePath) {
            ZStack {
                Color.reportBackground.ignoresSafeArea()
                content
            }
            .navigationTitle("리포트")
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load(week: viewModel.currentWeek) }
            .onReceive(NotificationCenter.default.publisher(for: .reportFeedbackSubmitted)) { _ in
                viewModel.hasSubmittedFeedback = true
                viewModel.feedbackExist = false
            }
            .navigationDestination(for: ReportRoute.self) { route in
                switch route {
                case .feedback:
                    ReportFeedbackScreen()
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView().progressViewStyle(.circular)
        } else if let error = viewModel.error {
            VStack(spacing: 12) {
                Text("문제가 발생했어요")
                Text(error)
                    .font(.reportCaption)
                    .foregroundColor(.reportTextSecondary)
                Button("다시 시도") {
                    Task { await viewModel.refresh() }
                }
            }
            .padding()
        } else {
            ScrollView {
                VStack(spacing: 16) {
                    WeekNavigatorView(
                        weekTitle: "\(viewModel.currentWeek)주차",
                        periodText: viewModel.weekTitle.isEmpty ? viewModel.periodText : viewModel.weekTitle,
                        onPrev: { Task { await viewModel.goPrevWeek() } },
                        onNext: { Task { await viewModel.goNextWeek() } }
                    )

                    FeedbackBannerView(
                        isVisible: viewModel.feedbackExist || viewModel.hasSubmittedFeedback,
                        action: {
                            routePath.append(.feedback)
                        },
                        isSubmitted: viewModel.hasSubmittedFeedback
                    )

                    ReportTopTabView(selected: $selectedTab)
                        .onChange(of: selectedTab) { newTab in
                            Task {
                                await loadDataForTab(newTab)
                            }
                        }

                    // 👇 탭에 따라 콘텐츠만 교체
                    tabContent
                }
                .padding(.horizontal, 16) // ✅ 항상 동일한 간격 유지
                .padding(.vertical, 12)
            }
        }
    }
    
    private func loadDataForTab(_ tab: ReportTopTab) async {
        switch tab {
        case .all:
            do {
                try await viewModel.loadWeight(week: viewModel.currentWeek)
            } catch {
                viewModel.error = "문제가 발생했어요: \(error.localizedDescription)"
            }
        case .workout:
            do {
                try await viewModel.loadExercise(week: viewModel.currentWeek)
            } catch {
                viewModel.error = "문제가 발생했어요: \(error.localizedDescription)"
            }
        case .diet:
            do {
                try await viewModel.loadFoods(week: viewModel.currentWeek)
            } catch {
                viewModel.error = "문제가 발생했어요: \(error.localizedDescription)"
            }
        }
    }

    /// ✅ 탭 콘텐츠만 바뀌는 ViewBuilder
    @ViewBuilder
    private var tabContent: some View {
        let maxWidthWithPadding = UIScreen.main.bounds.width - 32
        
        VStack {
            switch selectedTab {
            case .all:
                VStack(spacing: 16) {
                    WeightChartCard(
                        changeFromTarget: parseWeightChange(viewModel.changeFromTargetWeight),
                        changeFromInitial: parseWeightChange(viewModel.changeFromInitialWeight),
                        dailyWeights: convertBarsToDailyWeights(viewModel.weightBars)
                    )
                    .frame(maxWidth: maxWidthWithPadding)

                    EyeBodyCompareCard(nWeekText: "\(viewModel.currentWeek)주차")
                        .frame(maxWidth: maxWidthWithPadding)
                }

            case .workout:
                VStack(spacing: 16) {
                    WorkoutChartCard(
                        totalKcal: parseTotalCalories(viewModel.exerciseTotalConsumedText),
                        totalGoalKcal: parseGoalCalories(viewModel.exerciseTotalConsumedText),
                        avgKcal: parseAvgCalories(viewModel.exerciseAverageDailyText),
                        dailyKcals: convertBarsToDailyKcals(viewModel.exerciseBars)
                    )
                    .frame(maxWidth: maxWidthWithPadding)

                    WorkoutGoalStampCard(achievedDays: viewModel.achievedDays)
                        .frame(maxWidth: maxWidthWithPadding)
                }

            case .diet:
                VStack(spacing: 16) {
                    DietChartCard(
                        totalKcal: parseTotalCalories(viewModel.foodTotalConsumedText),
                        totalGoalKcal: parseGoalCalories(viewModel.foodTotalConsumedText),
                        avgKcal: parseAvgCalories(viewModel.foodAverageDailyText),
                        dailyKcals: convertBarsToDailyKcals(viewModel.foodBars)
                    )
                    .frame(maxWidth: maxWidthWithPadding)

                    DietGoalStampCard(achievedDays: viewModel.dietAchievedDays)
                        .frame(maxWidth: maxWidthWithPadding)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func convertBarsToDailyKcals(_ bars: [DayBar]) -> [DayOfWeek: Double?] {
        var dailyKcals: [DayOfWeek: Double?] = [:]
        
        for bar in bars {
            // Convert day string to DayOfWeek enum
            let dayOfWeek: DayOfWeek?
            switch bar.dayDisplay {
            case "월": dayOfWeek = .monday
            case "화": dayOfWeek = .tuesday  
            case "수": dayOfWeek = .wednesday
            case "목": dayOfWeek = .thursday
            case "금": dayOfWeek = .friday
            case "토": dayOfWeek = .saturday
            case "일": dayOfWeek = .sunday
            default: dayOfWeek = nil
            }
            
            if let day = dayOfWeek {
                dailyKcals[day] = bar.value
            }
        }
        
        return dailyKcals
    }
    
    private func convertBarsToDailyWeights(_ bars: [DayBar]) -> [DayOfWeek: Double?] {
        var dailyWeights: [DayOfWeek: Double?] = [:]
        
        for bar in bars {
            // Convert day string to DayOfWeek enum
            let dayOfWeek: DayOfWeek?
            switch bar.dayDisplay {
            case "월": dayOfWeek = .monday
            case "화": dayOfWeek = .tuesday  
            case "수": dayOfWeek = .wednesday
            case "목": dayOfWeek = .thursday
            case "금": dayOfWeek = .friday
            case "토": dayOfWeek = .saturday
            case "일": dayOfWeek = .sunday
            default: dayOfWeek = nil
            }
            
            if let day = dayOfWeek {
                dailyWeights[day] = bar.value
            }
        }
        
        return dailyWeights
    }
    
    // String parsing functions for existing UI components
    private func parseWeightChange(_ text: String) -> Double? {
        // "+2.5kg" -> 2.5, "-1.2kg" -> -1.2
        let cleanText = text.replacingOccurrences(of: "kg", with: "")
        return Double(cleanText)
    }
    
    private func parseTotalCalories(_ text: String) -> Int {
        // "1,670 / 1,750" -> 1670
        let components = text.split(separator: "/")
        if let first = components.first {
            let cleanText = String(first).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: "")
            return Int(cleanText) ?? 0
        }
        return 0
    }
    
    private func parseGoalCalories(_ text: String) -> Int {
        // "1,670 / 1,750" -> 1750
        let components = text.split(separator: "/")
        if components.count >= 2 {
            let cleanText = String(components[1]).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: "")
            return Int(cleanText) ?? 0
        }
        return 0
    }
    
    private func parseAvgCalories(_ text: String) -> Int {
        // "238" -> 238
        let cleanText = text.replacingOccurrences(of: ",", with: "")
        return Int(cleanText) ?? 0
    }
}

struct ReportScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReportScreen(viewModel: .preview)
    }
}
