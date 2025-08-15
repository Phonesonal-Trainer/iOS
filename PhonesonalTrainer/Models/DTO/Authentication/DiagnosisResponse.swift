//
//  DiagnosisResponse.swift
//  PhonesonalTrainer
//
//  Created by Assistant on 8/15/25.
//

import Foundation

// MARK: - 진단 API 응답 모델
struct DiagnosisResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DiagnosisResult
}

struct DiagnosisResult: Codable {
    let weight: Double                      // 현재 몸무게
    let targetWeight: Double               // 목표 몸무게
    let targetBMI: Double                  // 목표 BMI
    let targetMuscleMass: String           // 목표 골격근량 동향
    let bodyFatRate: Double                // 현재 체지방률
    let targetBodyFatRate: Double          // 목표 체지방률
    let recommendedNutrition: String       // 추천 영양소
    let recommendedCalories: Int           // 추천 칼로리
    let workoutFrequency: Int              // 운동 주기
    let cardioDaysPerWeek: Int            // 유산소 운동주기
    let cardioMinutesPerWeek: Int         // 유산소 운동시간
    let strengthTrainingDays: Int          // 무산소 운동주기
    let strengthTrainingTime: Int          // 무산소 운동시간
    let overallRecommendation: String      // 총평 한줄요약
    let bmi: Double                        // 현재 BMI
}

// MARK: - DiagnosisResult을 DiagnosisInputModel로 변환하는 Extension
extension DiagnosisResult {
    func toDiagnosisInputModel() -> DiagnosisInputModel {
        // 몸무게 변화 계산
        let weightChange = MetricChange(
            before: "\(Int(weight)) kg",
            after: "\(Int(targetWeight)) kg",
            diff: weight > targetWeight ? "-\(Int(weight - targetWeight))kg" : "+\(Int(targetWeight - weight))kg"
        )
        
        // BMI 변화 계산
        let bmiChange = MetricChange(
            before: String(format: "%.1f", bmi),
            after: String(format: "%.1f", targetBMI),
            diff: bmi > targetBMI ? String(format: "-%.1f", bmi - targetBMI) : String(format: "+%.1f", targetBMI - bmi)
        )
        
        // 체지방률 변화 계산
        let bodyFatChange = MetricChange(
            before: "\(Int(bodyFatRate))%",
            after: "\(Int(targetBodyFatRate))%",
            diff: bodyFatRate > targetBodyFatRate ? "-\(Int(bodyFatRate - targetBodyFatRate))%p" : "+\(Int(targetBodyFatRate - bodyFatRate))%p"
        )
        
        // 골격근량 동향
        let muscleMassChange = MetricChange(
            before: "-",
            after: targetMuscleMass,
            diff: nil
        )
        
        // 운동 목표 생성
        let exerciseGoals = [
            ExerciseGoal(
                type: "주기",
                mainInfo: "주 \(workoutFrequency)회 / 1시간",
                detail: nil
            ),
            ExerciseGoal(
                type: "무산소",
                mainInfo: "주 \(strengthTrainingDays)회 / \(strengthTrainingTime)분",
                detail: "상체/하체/전신 하루씩"
            ),
            ExerciseGoal(
                type: "유산소",
                mainInfo: "주 \(cardioDaysPerWeek)회 / \(cardioMinutesPerWeek / cardioDaysPerWeek)분",
                detail: nil
            )
        ]
        
        // 식단 목표 생성
        let dietGoals = [
            DietGoal(
                key: "영양소",
                value: recommendedNutrition
            ),
            DietGoal(
                key: "일일 섭취량",
                value: "\(recommendedCalories) ~ \(recommendedCalories + 100) kcal"
            )
        ]
        
        return DiagnosisInputModel(
            weightChange: weightChange,
            bmiChange: bmiChange,
            bodyFatChange: bodyFatChange,
            muscleMassChange: muscleMassChange,
            comment: overallRecommendation,
            exerciseGoals: exerciseGoals,
            dietGoals: dietGoals
        )
    }
}
