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

    // MARK: - New API Integration Properties
    @Published var weight: WeightReportDTO?
    @Published var exercise: ExerciseReportDTO?
    @Published var foods: FoodsReportDTO?
    @Published var weightBars: [DayBar] = []
    @Published var exerciseBars: [DayBar] = []
    @Published var foodBars: [DayBar] = []
    @Published var weekTitle: String = ""
    @Published var changeFromTargetWeight: String = ""
    @Published var changeFromInitialWeight: String = ""
    
    // MARK: - Exercise Specific Properties
    @Published var exerciseTotalConsumedText: String = ""
    @Published var exerciseAverageDailyText: String = ""
    @Published var achievedDays: Set<DayOfWeek> = []
    
    // MARK: - Foods Specific Properties
    @Published var foodTotalConsumedText: String = ""
    @Published var foodAverageDailyText: String = ""
    @Published var dietAchievedDays: Set<DayOfWeek> = []
    @Published var dietStampMessage: String = ""
    
    // Caches
    private var weightCache: [Int: WeightReportDTO] = [:]
    private var exerciseCache: [Int: ExerciseReportDTO] = [:]
    private var exerciseStampCache: [Int: ExerciseStampResult] = [:]
    private var foodsCache: [Int: FoodsReportDTO] = [:]

    private let repository: ReportRepositorying
    private let apiService: ReportAPIServicing

    init(repository: ReportRepositorying = ReportRepository(), 
         apiService: ReportAPIServicing = MockReportAPIService()) {
        self.repository = repository
        self.apiService = apiService
        self.currentWeek = 0
        computePeriod(for: Date())
    }

    func load(week: Int) async {
        isLoading = true
        error = nil
        do {
            // Load all three reports in parallel
            async let weightTask: Void = loadWeight(week: week)
            async let exerciseTask: Void = loadExercise(week: week)  
            async let foodsTask: Void = loadFoods(week: week)
            
            try await weightTask
            try await exerciseTask
            try await foodsTask
            
            currentWeek = week
            updateWeekTitle()
        } catch {
            self.error = "문제가 발생했어요: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func loadWeight(week: Int) async throws {
        if let cached = weightCache[week] {
            weight = cached
            updateWeightBars(from: cached)
            return
        }
        
        let data = try await apiService.fetchWeight(week: week)
        weightCache[week] = data
        weight = data
        feedbackExist = data.feedbackExist
        changeFromTargetWeight = data.changeFromTargetWeight
        changeFromInitialWeight = data.changeFromInitialWeight
        updateWeightBars(from: data)
    }
    
    func loadExercise(week: Int) async throws {
        // Check cache first
        if let cachedExercise = exerciseCache[week],
           let cachedStamp = exerciseStampCache[week] {
            exercise = cachedExercise
            updateExerciseData(from: cachedExercise, stamp: cachedStamp)
            return
        }
        
        // Fetch both exercise and stamp data in parallel
        async let exerciseTask = apiService.fetchExercise(week: week)
        async let stampTask = apiService.fetchExerciseStamp(week: week)
        
        let exerciseData = try await exerciseTask
        let stampData = try await stampTask
        
        // Cache the results
        exerciseCache[week] = exerciseData
        exerciseStampCache[week] = stampData
        
        // Update state
        exercise = exerciseData
        updateExerciseData(from: exerciseData, stamp: stampData)
    }
    
    func loadFoods(week: Int) async throws {
        if let cached = foodsCache[week] {
            foods = cached
            updateFoodsData(from: cached)
            return
        }
        
        let data = try await apiService.fetchFoods(week: week)
        foodsCache[week] = data
        foods = data
        updateFoodsData(from: data)
    }

    func goPrevWeek() async { 
        currentWeek -= 1
        await load(week: currentWeek) 
    }
    
    func goNextWeek() async { 
        currentWeek += 1
        await load(week: currentWeek) 
    }
    
    func refresh() async { 
        // Clear caches for current week
        weightCache.removeValue(forKey: currentWeek)
        exerciseCache.removeValue(forKey: currentWeek)
        exerciseStampCache.removeValue(forKey: currentWeek)
        foodsCache.removeValue(forKey: currentWeek)
        await load(week: currentWeek) 
    }

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
    

    
    // MARK: - Week Title Update
    private func updateWeekTitle() {
        if let weightData = weight {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let startDate = formatter.date(from: weightData.weekStart),
               let endDate = formatter.date(from: weightData.weekEnd) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "yy.MM.dd"
                weekTitle = "\(displayFormatter.string(from: startDate)) ~ \(displayFormatter.string(from: endDate))"
            } else {
                weekTitle = "\(currentWeek)주차"
            }
        } else {
            weekTitle = "\(currentWeek)주차"
        }
    }
    
    // MARK: - Bar Update Methods
    private func updateWeightBars(from data: WeightReportDTO) {
        let sortedData = DayKeyMapper.sortedDayKeys(from: data.dailyWeight)
        let values = sortedData.map { $0.1 }
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 100
        let range = maxValue - minValue
        
        weightBars = sortedData.map { (dayKey, value) in
            let normalizedHeight: CGFloat = range > 0 ? CGFloat((value - minValue) / range) : 0.5
            return DayBar(
                day: dayKey,
                dayDisplay: DayKeyMapper.displayName(for: dayKey),
                value: value,
                target: 0, // Weight doesn't have a target from API
                percent: 0,
                height: normalizedHeight,
                color: .good // Weight bars are neutral colored
            )
        }
    }
    
    private func updateExerciseData(from exerciseData: ExerciseReportDTO, stamp: ExerciseStampResult) {
        // Update text displays
        exerciseTotalConsumedText = "\(formatKcal(exerciseData.totalConsumedCalories)) / \(formatKcal(exerciseData.totalTargetCalories))"
        exerciseAverageDailyText = formatKcal(exerciseData.averageDailyCalories)
        
        // Update achieved days from stamp
        achievedDays = getAchievedDaysFromStamp(stamp)
        
        // Calculate daily target
        let dailyTarget = exerciseData.totalTargetCalories / 7.0
        
        // Generate exercise bars
        var bars: [DayBar] = []
        let dailyValues: [Double] = Weekday.orderedWeekdays.map { weekday in
            exerciseData.dailyCalories[weekday.rawValue] ?? 0.0
        }
        let maxDaily = dailyValues.max() ?? 0
        
        for weekday in Weekday.orderedWeekdays {
            let actual = exerciseData.dailyCalories[weekday.rawValue] ?? 0.0
            
            let (percent, height, color) = calculateBarMetrics(
                actual: actual,
                target: dailyTarget,
                maxValue: maxDaily
            )
            
            bars.append(DayBar(
                day: weekday.rawValue,
                dayDisplay: weekday.displayKorean,
                value: actual,
                target: dailyTarget,
                percent: percent,
                height: height,
                color: color
            ))
        }
        
        exerciseBars = bars
    }
    
    // MARK: - Helper Functions
    private func formatKcal(_ calories: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return "\(formatter.string(from: NSNumber(value: Int(calories))) ?? "0")kcal"
    }
    
    private func getAchievedDaysFromStamp(_ stamp: ExerciseStampResult) -> Set<DayOfWeek> {
        var achieved: Set<DayOfWeek> = []
        
        if stamp.mondayStamp { achieved.insert(.monday) }
        if stamp.tuesdayStamp { achieved.insert(.tuesday) }
        if stamp.wednesdayStamp { achieved.insert(.wednesday) }
        if stamp.thursdayStamp { achieved.insert(.thursday) }
        if stamp.fridayStamp { achieved.insert(.friday) }
        if stamp.saturdayStamp { achieved.insert(.saturday) }
        if stamp.sundayStamp { achieved.insert(.sunday) }
        
        return achieved
    }
    
    private func calculateBarMetrics(actual: Double, target: Double, maxValue: Double) -> (percent: Double?, height: CGFloat, color: ProgressZone) {
        if target > 0 {
            // Normal case: calculate percentage
            let percent = (actual / target) * 100
            let zone = ProgressZone.zone(for: percent)
            let height = ProgressZone.heightFactor(for: percent)
            return (percent, height, zone)
        } else {
            // Edge case: target is 0, use normalized height and neutral color
            let height: CGFloat = maxValue > 0 ? CGFloat(actual / maxValue) : 0
            return (nil, height, .good) // Use neutral color for zero target
        }
    }
    
    private func updateFoodsData(from foodsData: FoodsReportDTO) {
        // Update text displays
        foodTotalConsumedText = "\(formatKcal(foodsData.totalConsumedCalories)) / \(formatKcal(foodsData.totalTargetCalories))"
        foodAverageDailyText = formatKcal(foodsData.averageDailyCalories)
        
        // Update stamp message and achieved days
        dietStampMessage = foodsData.stampMessage
        dietAchievedDays = getDietAchievedDaysFromStamps(foodsData.dailyStamps)
        
        // Calculate daily target
        let dailyTarget = foodsData.totalTargetCalories / 7.0
        
        // Generate food bars
        var bars: [DayBar] = []
        let dailyValues: [Double] = Weekday.orderedWeekdays.map { weekday in
            foodsData.dailyCalories[weekday.rawValue] ?? 0.0
        }
        let maxDaily = dailyValues.max() ?? 0
        
        for weekday in Weekday.orderedWeekdays {
            let actual = foodsData.dailyCalories[weekday.rawValue] ?? 0.0
            
            let (percent, height, color) = calculateBarMetrics(
                actual: actual,
                target: dailyTarget,
                maxValue: maxDaily
            )
            
            bars.append(DayBar(
                day: weekday.rawValue,
                dayDisplay: weekday.displayKorean,
                value: actual,
                target: dailyTarget,
                percent: percent,
                height: height,
                color: color
            ))
        }
        
        foodBars = bars
    }
    
    private func getDietAchievedDaysFromStamps(_ stamps: [String: Bool?]?) -> Set<DayOfWeek> {
        guard let stamps = stamps else { return [] }
        
        var achieved: Set<DayOfWeek> = []
        for weekday in Weekday.orderedWeekdays {
            if stamps[weekday.rawValue] == true {
                achieved.insert(weekday.dayOfWeek)
            }
        }
        return achieved
    }
}



