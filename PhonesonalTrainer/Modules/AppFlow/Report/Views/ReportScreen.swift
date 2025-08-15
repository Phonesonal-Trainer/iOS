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
                        periodText: viewModel.periodText,
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

                    // 👇 탭에 따라 콘텐츠만 교체
                    tabContent
                }
                .padding(.horizontal, horizontalInset) // ✅ 항상 동일한 간격 유지
                .padding(.vertical, 12)
            }
        }
    }

    /// ✅ 탭 콘텐츠만 바뀌는 ViewBuilder
    @ViewBuilder
    private var tabContent: some View {
        Group {
            switch selectedTab {
            case .all:
                VStack(spacing: 16) {
                    WeightChartCard(
                        changeFromTarget: viewModel.changeFromTarget,
                        changeFromInitial: viewModel.changeFromInitial,
                        dailyWeights: viewModel.dailyWeights
                    )
                    .frame(maxWidth: .infinity)

                    EyeBodyCompareCard(nWeekText: "\(viewModel.currentWeek)주차")
                        .frame(maxWidth: .infinity)
                }

            case .workout:
                VStack(spacing: 16) {
                    WorkoutChartCard(
                        totalKcal: 1234,
                        totalGoalKcal: 2345,
                        avgKcal: 123,
                        dailyKcals: viewModel.dailyWeights.mapValues { opt in opt.map { $0 * 40 } }
                    )
                    .frame(maxWidth: .infinity)

                    WorkoutGoalStampCard(achievedDays: [.monday, .wednesday, .friday])
                        .frame(maxWidth: .infinity)
                }

            case .diet:
                VStack(spacing: 16) {
                    DietChartCard(
                        totalKcal: 1234,
                        totalGoalKcal: 2345,
                        avgKcal: 123,
                        dailyKcals: viewModel.dailyWeights.mapValues { opt in opt.map { $0 * 30 } }
                    )
                    .frame(maxWidth: .infinity)

                    DietGoalStampCard(achievedDays: [.monday, .tuesday, .thursday])
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity) // ✅ 그룹 전체에도 추가
    }
}

struct ReportScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReportScreen(viewModel: .preview)
    }
}
