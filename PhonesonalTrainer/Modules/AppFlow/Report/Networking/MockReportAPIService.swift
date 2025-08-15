//
//  MockReportAPIService.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 2025-01-25.
//

import Foundation

class MockReportAPIService: ReportAPIServicing {
    
    func fetchWeight(week: Int) async throws -> WeightReportDTO {
        return WeightReportDTO(
            week: week,
            weekStart: "2025-01-20",
            weekEnd: "2025-01-26",
            feedbackExist: true,
            dailyWeight: [
                "MONDAY": 70.5,
                "TUESDAY": 70.2,
                "WEDNESDAY": 70.8,
                "THURSDAY": 70.3,
                "FRIDAY": 70.1,
                "SATURDAY": 69.9,
                "SUNDAY": 70.0
            ],
            changeFromTargetWeight: "+2.5kg",
            changeFromInitialWeight: "-1.2kg"
        )
    }
    
    func fetchExercise(week: Int) async throws -> ExerciseReportDTO {
        return ExerciseReportDTO(
            week: week,
            weekStart: "2025-01-20",
            weekEnd: "2025-01-26",
            feedbackExist: true,
            dailyCalories: [
                "MONDAY": 250,
                "TUESDAY": 180,
                "WEDNESDAY": 320,
                "THURSDAY": 290,
                "FRIDAY": 200,
                "SATURDAY": 150,
                "SUNDAY": 280
            ],
            totalConsumedCalories: 1670,
            totalTargetCalories: 1750,
            averageDailyCalories: 238.6
        )
    }
    
    func fetchExerciseStamp(week: Int) async throws -> ExerciseStampResult {
        return ExerciseStampResult(
            weekStartDate: "2025-01-20",
            mondayStamp: true,
            tuesdayStamp: false,
            wednesdayStamp: true,
            thursdayStamp: true,
            fridayStamp: false,
            saturdayStamp: false,
            sundayStamp: true
        )
    }
    
    func fetchFoods(week: Int) async throws -> FoodsReportDTO {
        return FoodsReportDTO(
            week: week,
            weekStart: "2025-01-20",
            weekEnd: "2025-01-26",
            feedbackExist: true,
            totalConsumedCalories: 11200,
            totalTargetCalories: 12600,
            averageDailyCalories: 1600,
            dailyCalories: [
                "MONDAY": 1650,
                "TUESDAY": 1450,
                "WEDNESDAY": 1720,
                "THURSDAY": 1580,
                "FRIDAY": 1380,
                "SATURDAY": 1620,
                "SUNDAY": 1800
            ],
            dailyStamps: [
                "MONDAY": true,
                "TUESDAY": false,
                "WEDNESDAY": true,
                "THURSDAY": true,
                "FRIDAY": false,
                "SATURDAY": true,
                "SUNDAY": true
            ],
            stampMessage: "이번 주 식단 목표를 잘 달성했어요!"
        )
    }
}
