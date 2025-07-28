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
    
    // 사용자 입력 기반 초기화
    init(height: String, weight: String, bodyFat: String?, muscleMass: String?) {
        self.comment = "입력하신 정보를 기반으로 맞춤형 진단을 제공합니다."
        
        // 몸무게
        self.weightChange = MetricChange(
            before: "\(weight) kg",
            after: "",
            diff: nil
        )
        
        // BMI
        self.bmiChange = MetricChange(
            before: DiagnosisModel.calcBMI(height: height, weight: weight),
            after: "",
            diff: nil
        )
        
        // 체지방률 (optional)
        if let bodyFat = bodyFat, !bodyFat.isEmpty {
            self.bodyFatChange = MetricChange(
                before: "\(bodyFat) %",
                after: "",
                diff: nil
            )
        } else {
            self.bodyFatChange = nil
        }
        
        // 골격근량 (optional)
        if let muscleMass = muscleMass, !muscleMass.isEmpty {
            self.muscleMassChange = MetricChange(
                before: "\(muscleMass) kg",
                after: "",
                diff: nil
            )
        } else {
            self.muscleMassChange = nil
        }
        
        // 기본 목표 (초기화)
        self.exerciseGoals = []
        self.dietGoals = []
    }
    
    // BMI 계산
    private static func calcBMI(height: String, weight: String) -> String {
        guard let h = Double(height), let w = Double(weight), h > 0 else { return "-" }
        let bmi = w / pow(h / 100.0, 2)
        return String(format: "%.1f", bmi)
    }
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
    var type: String
    var mainInfo: String
    var detail: String?
}

// MARK: - DietGoal
struct DietGoal: Identifiable {
    var id = UUID()
    var key: String
    var value: String
}

// MARK: - Dummy Data (개발 중 테스트용)
extension DiagnosisModel {
    static var dummy: DiagnosisModel {
        var model = DiagnosisModel(
            height: "165",
            weight: "55",
            bodyFat: "30",
            muscleMass: "23"
        )
        // 필요 시 테스트용 데이터 세팅
        model.comment = "어쩌구저쩌구 코멘트"
        model.exerciseGoals = [
            ExerciseGoal(type: "주기", mainInfo: "주 3회 / 1시간"),
            ExerciseGoal(type: "무산소", mainInfo: "주 3회 / 40분", detail: "상체/하체/전신 하루씩"),
            ExerciseGoal(type: "유산소", mainInfo: "주 2회 / 20분")
        ]
        model.dietGoals = [
            DietGoal(key: "영양소", value: "고단백 / 저지방"),
            DietGoal(key: "일일 섭취량", value: "1,300 ~ 1,400 kcal")
        ]
        return model
    }
}
