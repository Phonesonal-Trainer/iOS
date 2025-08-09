//
//  OnboardingViewModel.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//

import Foundation



final class OnboardingViewModel: ObservableObject {

    // ✅ 서버 응답용 유저 모델
    @Published var user: User = .empty

    // ✅ 텍스트 입력 바인딩용 (사용자가 입력한 값)
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var bodyFat: String = ""
    @Published var muscleMass: String = ""
    @Published var nickname: String = ""
    @Published var age: Int = 0
    @Published var gender: String = "" // 예: "MALE" or "FEMALE"
    @Published var purpose: String = "" // 예: "벌크업", "체중감량" 등
    @Published var deadline: Int = 0 // 예: 30, 60 등 기간 일 수
    @Published var tempToken: String = ""
    @Published var bodyFatRate: String = ""



    // ✅ 진단 요청 모델 생성
    func toDiagnosisModel() -> DiagnosisInputModel {
        let heightDouble = Double(height) ?? 0
        let weightDouble = Double(weight) ?? 0
        let bodyFatDouble = Double(bodyFat)
        let muscleMassDouble = Double(muscleMass)

        // 임시 MetricChange 모델 생성 (실제로는 진단 로직 필요)
        let weightChange = MetricChange(before: "\(weightDouble)", after: "\(weightDouble)", diff: nil)
        let bmiChange = MetricChange(before: "0", after: "0", diff: nil)
        let bodyFatChange = bodyFatDouble != nil ? MetricChange(before: "\(bodyFatDouble!)", after: "\(bodyFatDouble!)", diff: nil) : nil
        let muscleMassChange = muscleMassDouble != nil ? MetricChange(before: "\(muscleMassDouble!)", after: "\(muscleMassDouble!)", diff: nil) : nil

        return DiagnosisInputModel(
            weightChange: weightChange,
            bmiChange: bmiChange,
            bodyFatChange: bodyFatChange,
            muscleMassChange: muscleMassChange,
            comment: "임시 진단 코멘트입니다.",
            exerciseGoals: [],
            dietGoals: []
        )
    }
}
