//
//  DiagnosisModel.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import Foundation

// MARK: - DiagnosisModel
struct DiagnosisModel {
    var comment: String
    var weightChange: MetricChange
    var bmiChange: MetricChange
    var bodyFatChange: MetricChange?
    var muscleMassChange: MetricChange?
    var exerciseGoals: [ExerciseGoal]
    var dietGoals: [DietGoal]
}

// MARK: - MetricChange
struct MetricChange {
    var before: String
    var after: String
    var diff: String?
}

// MARK: - ExerciseGoal
struct ExerciseGoal: Identifiable {
    var id = UUID()
    var type: String         // 예: "주기", "무산소", "유산소"
    var mainInfo: String     // 예: "주 3회 / 1시간"
    var detail: String?      // 예: "상체/하체/전신 하루씩"
}

// MARK: - DietGoal
struct DietGoal: Identifiable {
    var id = UUID()
    var key: String          // 예: "영양소"
    var value: String        // 예: "고단백 / 저지방"
}

// MARK: - Dummy Data (개발 중 테스트용)
extension DiagnosisModel {
    static var dummy: DiagnosisModel {
        return DiagnosisModel(
            comment: "어쩌구저쩌구 코멘트",
            weightChange: MetricChange(before: "55 kg", after: "49 kg", diff: "-6kg"),
            bmiChange: MetricChange(before: "21.5", after: "19.1", diff: "-2.4"),
            bodyFatChange: MetricChange(before: "30%", after: "22%", diff: "-8%p"),
            muscleMassChange: MetricChange(before: "유지 또는 소폭 증가", after: "", diff: nil),
            exerciseGoals: [
                ExerciseGoal(type: "주기", mainInfo: "주 3회 / 1시간"),
                ExerciseGoal(type: "무산소", mainInfo: "주 3회 / 40분", detail: "상체/하체/전신 하루씩"),
                ExerciseGoal(type: "유산소", mainInfo: "주 2회 / 20분")
            ],
            dietGoals: [
                DietGoal(key: "영양소", value: "고단백 / 저지방"),
                DietGoal(key: "일일 섭취량", value: "1,300 ~ 1,400 kcal")
            ]
        )
    }
}
