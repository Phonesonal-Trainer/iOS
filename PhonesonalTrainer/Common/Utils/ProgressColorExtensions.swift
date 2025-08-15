//
//  ProgressColorExtensions.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 2025-01-25.
//

import SwiftUI

extension ProgressZone {
    var color: Color {
        switch self {
        case .underRed, .overRed:
            return .red
        case .underYellow, .overYellow:
            return .yellow
        case .good:
            return .green
        }
    }
}

extension Color {
    static func progressColor(for percent: Double) -> Color {
        return ProgressZone.zone(for: percent).color
    }
}

// MARK: - Day Key Utilities
struct DayKeyMapper {
    static let englishDays = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
    static let koreanDays = ["월", "화", "수", "목", "금", "토", "일"]
    static let koreanToEnglish: [String: String] = [
        "월": "mon", "화": "tue", "수": "wed", "목": "thu",
        "금": "fri", "토": "sat", "일": "sun"
    ]
    static let englishToKorean: [String: String] = [
        "mon": "월", "tue": "화", "wed": "수", "thu": "목",
        "fri": "금", "sat": "토", "sun": "일"
    ]
    
    static func sortedDayKeys<T>(from dictionary: [String: T]) -> [(String, T)] {
        let keys = Array(dictionary.keys)
        
        // 영어 요일 키가 있는지 확인
        if keys.contains(where: { englishDays.contains($0) }) {
            return englishDays.compactMap { day in
                guard let value = dictionary[day] else { return nil }
                return (day, value)
            }
        }
        
        // 한글 요일 키가 있는지 확인
        if keys.contains(where: { koreanDays.contains($0) }) {
            return koreanDays.compactMap { day in
                guard let value = dictionary[day] else { return nil }
                return (day, value)
            }
        }
        
        // 둘 다 아니면 원래 순서 유지
        return keys.sorted().compactMap { key in
            guard let value = dictionary[key] else { return nil }
            return (key, value)
        }
    }
    
    static func displayName(for dayKey: String) -> String {
        return englishToKorean[dayKey] ?? dayKey
    }
}
