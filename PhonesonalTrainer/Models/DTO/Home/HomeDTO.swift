//
//  HomeDTO.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/15/25.
//
import Foundation

// MARK: - /home/{userId}/main Response
struct HomeMainResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: HomeMainResult
}

struct HomeMainResult: Decodable {
    let main: HomeMainBlock
    let exercise: HomeExerciseBlock
    let meal: HomeMealBlock
}

struct HomeMainBlock: Decodable {
    let userId: Int
    let targetCalories: Int
    let todayCalories: Int
    let targetWeight: Int
    let comment: String
    let presentWeek: Int
    let date: String
    let koreanDate: String
}

struct HomeExerciseBlock: Decodable {
    let todayBurnedCalories: Int
    let todayRecommendBurnedCalories: Int   // 내부 표준명

    let anaerobicExerciseTime: Int
    let aerobicExerciseTime: Int
    let exercisePercentage: Int
    let focusedBodyPart: String
    let exerciseStatus: String

    enum CodingKeys: String, CodingKey {
        case todayBurnedCalories
        case todayRecommendBurnedCalories           // 정상 키
        case todayRecommanedBurnedCalories          // 스웨거 오타 키
        case anaerobicExerciseTime, aerobicExerciseTime
        case exercisePercentage, focusedBodyPart, exerciseStatus
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        todayBurnedCalories = try c.decode(Int.self, forKey: .todayBurnedCalories)
        if let v = try? c.decode(Int.self, forKey: .todayRecommendBurnedCalories) {
            todayRecommendBurnedCalories = v
        } else if let v = try? c.decode(Int.self, forKey: .todayRecommanedBurnedCalories) {
            todayRecommendBurnedCalories = v
        } else {
            todayRecommendBurnedCalories = 0
        }
        anaerobicExerciseTime = try c.decode(Int.self, forKey: .anaerobicExerciseTime)
        aerobicExerciseTime   = try c.decode(Int.self, forKey: .aerobicExerciseTime)
        exercisePercentage    = try c.decode(Int.self, forKey: .exercisePercentage)
        focusedBodyPart       = try c.decode(String.self, forKey: .focusedBodyPart)
        exerciseStatus        = try c.decode(String.self, forKey: .exerciseStatus)
    }
    
    // 더미 데이터용 기본 초기화자
    init(todayBurnedCalories: Int, todayRecommendBurnedCalories: Int, anaerobicExerciseTime: Int, aerobicExerciseTime: Int, exercisePercentage: Int, focusedBodyPart: String, exerciseStatus: String) {
        self.todayBurnedCalories = todayBurnedCalories
        self.todayRecommendBurnedCalories = todayRecommendBurnedCalories
        self.anaerobicExerciseTime = anaerobicExerciseTime
        self.aerobicExerciseTime = aerobicExerciseTime
        self.exercisePercentage = exercisePercentage
        self.focusedBodyPart = focusedBodyPart
        self.exerciseStatus = exerciseStatus
    }
}

struct HomeMealBlock: Decodable {
    let todayRecommendedCalories: Int
    let todayConsumedCalorie: Int
    let carb: Int
    let protein: Int
    let fat: Int
    let caloriePercentage: Int
    let calorieStatus: String
}
