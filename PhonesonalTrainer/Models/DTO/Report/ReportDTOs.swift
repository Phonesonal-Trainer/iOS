//
//  ReportDTOs.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 2025-01-25.
//

import Foundation

// MARK: - API Envelope
struct APIEnvelope<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}

// MARK: - Weight Report
struct WeightReportDTO: Codable {
    let week: Int
    let weekStart: String
    let weekEnd: String
    let feedbackExist: Bool
    let dailyWeight: [String: Double]
    let changeFromTargetWeight: String
    let changeFromInitialWeight: String
}

// MARK: - Exercise Report
struct ExerciseReportDTO: Codable {
    let week: Int
    let weekStart: String
    let weekEnd: String
    let feedbackExist: Bool
    let dailyCalories: [String: Double]
    let totalConsumedCalories: Double
    let totalTargetCalories: Double
    let averageDailyCalories: Double
    
    // Custom decoder to handle null values as 0.0
    enum CodingKeys: String, CodingKey {
        case week, weekStart, weekEnd, feedbackExist, dailyCalories
        case totalConsumedCalories, totalTargetCalories, averageDailyCalories
    }
    
    // Regular init for testing/mocking
    init(week: Int, weekStart: String, weekEnd: String, feedbackExist: Bool,
         dailyCalories: [String: Double], totalConsumedCalories: Double,
         totalTargetCalories: Double, averageDailyCalories: Double) {
        self.week = week
        self.weekStart = weekStart
        self.weekEnd = weekEnd
        self.feedbackExist = feedbackExist
        self.dailyCalories = dailyCalories
        self.totalConsumedCalories = totalConsumedCalories
        self.totalTargetCalories = totalTargetCalories
        self.averageDailyCalories = averageDailyCalories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        week = try container.decode(Int.self, forKey: .week)
        weekStart = try container.decode(String.self, forKey: .weekStart)
        weekEnd = try container.decode(String.self, forKey: .weekEnd)
        feedbackExist = try container.decode(Bool.self, forKey: .feedbackExist)
        totalConsumedCalories = try container.decode(Double.self, forKey: .totalConsumedCalories)
        totalTargetCalories = try container.decode(Double.self, forKey: .totalTargetCalories)
        averageDailyCalories = try container.decode(Double.self, forKey: .averageDailyCalories)
        
        // Handle null values in dailyCalories
        let rawDailyCalories = try container.decode([String: Double?].self, forKey: .dailyCalories)
        dailyCalories = rawDailyCalories.mapValues { $0 ?? 0.0 }
    }
}

// MARK: - Exercise Stamp
struct ExerciseStampResult: Codable {
    let weekStartDate: String
    let mondayStamp: Bool
    let tuesdayStamp: Bool
    let wednesdayStamp: Bool
    let thursdayStamp: Bool
    let fridayStamp: Bool
    let saturdayStamp: Bool
    let sundayStamp: Bool
}

// MARK: - Foods Report  
struct FoodsReportDTO: Codable {
    let week: Int
    let weekStart: String
    let weekEnd: String
    let feedbackExist: Bool
    let totalConsumedCalories: Double
    let totalTargetCalories: Double
    let averageDailyCalories: Double
    let dailyCalories: [String: Double]  // null을 0.0으로 처리
    let dailyStamps: [String: Bool?]?     // true/false/null
    let stampMessage: String
    
    // Custom decoder to handle null values as 0.0
    enum CodingKeys: String, CodingKey {
        case week, weekStart, weekEnd, feedbackExist, dailyCalories
        case totalConsumedCalories, totalTargetCalories, averageDailyCalories
        case dailyStamps, stampMessage
    }
    
    // Regular init for testing/mocking
    init(week: Int, weekStart: String, weekEnd: String, feedbackExist: Bool,
         totalConsumedCalories: Double, totalTargetCalories: Double, averageDailyCalories: Double,
         dailyCalories: [String: Double], dailyStamps: [String: Bool?]?, stampMessage: String) {
        self.week = week
        self.weekStart = weekStart
        self.weekEnd = weekEnd
        self.feedbackExist = feedbackExist
        self.totalConsumedCalories = totalConsumedCalories
        self.totalTargetCalories = totalTargetCalories
        self.averageDailyCalories = averageDailyCalories
        self.dailyCalories = dailyCalories
        self.dailyStamps = dailyStamps
        self.stampMessage = stampMessage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        week = try container.decode(Int.self, forKey: .week)
        weekStart = try container.decode(String.self, forKey: .weekStart)
        weekEnd = try container.decode(String.self, forKey: .weekEnd)
        feedbackExist = try container.decode(Bool.self, forKey: .feedbackExist)
        totalConsumedCalories = try container.decode(Double.self, forKey: .totalConsumedCalories)
        totalTargetCalories = try container.decode(Double.self, forKey: .totalTargetCalories)
        averageDailyCalories = try container.decode(Double.self, forKey: .averageDailyCalories)
        dailyStamps = try container.decodeIfPresent([String: Bool?].self, forKey: .dailyStamps)
        stampMessage = try container.decode(String.self, forKey: .stampMessage)
        
        // Handle null values in dailyCalories
        let rawDailyCalories = try container.decode([String: Double?].self, forKey: .dailyCalories)
        dailyCalories = rawDailyCalories.mapValues { $0 ?? 0.0 }
    }
}

// MARK: - Weekday Enum
enum Weekday: String, CaseIterable {
    case MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
    
    var displayKorean: String {
        switch self {
        case .MONDAY: return "월"
        case .TUESDAY: return "화"
        case .WEDNESDAY: return "수"
        case .THURSDAY: return "목"
        case .FRIDAY: return "금"
        case .SATURDAY: return "토"
        case .SUNDAY: return "일"
        }
    }
    
    var dayOfWeek: DayOfWeek {
        switch self {
        case .MONDAY: return .monday
        case .TUESDAY: return .tuesday
        case .WEDNESDAY: return .wednesday
        case .THURSDAY: return .thursday
        case .FRIDAY: return .friday
        case .SATURDAY: return .saturday
        case .SUNDAY: return .sunday
        }
    }
    
    static var orderedWeekdays: [Weekday] {
        return [.MONDAY, .TUESDAY, .WEDNESDAY, .THURSDAY, .FRIDAY, .SATURDAY, .SUNDAY]
    }
}

// MARK: - Day Bar Model
struct DayBar: Identifiable {
    let id = UUID()
    let day: String
    let dayDisplay: String
    let value: Double
    let target: Double
    let percent: Double?
    let height: CGFloat
    let color: ProgressZone
}

// MARK: - Progress Zone
enum ProgressZone: CaseIterable {
    case underRed    // < 60%
    case underYellow // 60% ~ < 90%
    case good        // 90% ~ 110%
    case overYellow  // > 110% ~ 140%
    case overRed     // > 140%
    
    static func zone(for percent: Double) -> ProgressZone {
        switch percent {
        case ..<60:
            return .underRed
        case 60..<90:
            return .underYellow
        case 90...110:
            return .good
        case 110...140:
            return .overYellow
        default:
            return .overRed
        }
    }
    
    static func heightFactor(for percent: Double) -> CGFloat {
        let clampedPercent = min(max(percent, 0), 140)
        return CGFloat(clampedPercent / 140.0)
    }
}
