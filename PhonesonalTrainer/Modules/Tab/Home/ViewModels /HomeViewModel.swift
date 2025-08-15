//
//  HomeViewModel.swift
//  PhonesonalTrainer
//

import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    // ===== 상태 =====
    @Published var isLoading = false
    @Published var errorText: String?

    // ====== result.main (Swagger) ======
    @Published var userId: Int = 0
    @Published var targetCalories: Int = 0
    @Published var todayCalories: Int = 0
    @Published var targetWeight: Int = 0
    @Published var comment: String = ""
    @Published var presentWeek: Int = 0
    @Published var dateString: String = ""     // "2025-08-14"
    @Published var koreanDate: String = ""     // 한국어 날짜 문자열

    // ====== result.exercise (Swagger) ======
    @Published var todayBurnedCalories: Int = 0
    @Published var todayRecommendBurnedCalories: Int = 0   // Swagger 오타키 대응은 DTO에서 처리
    @Published var anaerobicExerciseTime: Int = 0
    @Published var aerobicExerciseTime: Int = 0
    @Published var exercisePercentage: Int = 0
    @Published var focusedBodyPart: String = ""
    @Published var exerciseStatus: String = ""

    // ====== result.meal (Swagger) ======
    @Published var todayRecommendedCalories: Int = 0
    @Published var todayConsumedCalorie: Int = 0
    @Published var carb: Int = 0
    @Published var protein: Int = 0
    @Published var fat: Int = 0
    @Published var caloriePercentage: Int = 0
    @Published var calorieStatus: String = ""

    // ===== 기존 뷰 호환용 alias(Computed) =====
    // 헤더
    var weekForHeader: Int { presentWeek }
    var dateTextForHeader: String { koreanDate.isEmpty ? dateString : koreanDate }

    // 식단 게이지 뷰에서 쓰던 이름
    var kcalConsumed: Int { todayConsumedCalorie }
    var kcalRecommended: Int { todayRecommendedCalories }

    // 운동 게이지/정보 뷰에서 쓰던 이름
    var burnedKcal: Int { todayBurnedCalories }
    var burnedKcalTarget: Int { todayRecommendBurnedCalories }
    var anaerobicMin: Int { anaerobicExerciseTime }
    var aerobicMin: Int { aerobicExerciseTime }
    var focusPart: String { focusedBodyPart }

    // 서버 "yyyy-MM-dd" 기준 Date 변환 (필요 시)
    func dateFromServerString() -> Date? {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: dateString)
    }

    // ===== API 호출 =====
    func load(userId: Int) async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            // HomeDTO.swift에 정의된 타입 사용:
            // HomeMainResponse / HomeMainResult / HomeMainBlock / HomeExerciseBlock / HomeMealBlock
            let res = try await HomeAPI.fetchHomeMain(userId: userId)

            // main
            let m = res.result.main
            self.userId = m.userId
            self.targetCalories = m.targetCalories
            self.todayCalories = m.todayCalories
            self.targetWeight = m.targetWeight
            self.comment = m.comment
            self.presentWeek = m.presentWeek
            self.dateString = m.date
            self.koreanDate = m.koreanDate

            // exercise
            let ex = res.result.exercise
            self.todayBurnedCalories = ex.todayBurnedCalories
            self.todayRecommendBurnedCalories = ex.todayRecommendBurnedCalories // DTO에서 오타키 흡수
            self.anaerobicExerciseTime = ex.anaerobicExerciseTime
            self.aerobicExerciseTime = ex.aerobicExerciseTime
            self.exercisePercentage = ex.exercisePercentage
            self.focusedBodyPart = ex.focusedBodyPart
            self.exerciseStatus = ex.exerciseStatus

            // meal
            let meal = res.result.meal
            self.todayRecommendedCalories = meal.todayRecommendedCalories
            self.todayConsumedCalorie = meal.todayConsumedCalorie
            self.carb = meal.carb
            self.protein = meal.protein
            self.fat = meal.fat
            self.caloriePercentage = meal.caloriePercentage
            self.calorieStatus = meal.calorieStatus

        } catch {
            self.errorText = "홈 데이터 로드 실패: \(error.localizedDescription)"
        }
    }
}
@MainActor
extension HomeViewModel {
    func refreshAfterWeightChange() async {
        let uid = UserDefaults.standard.integer(forKey: "userId")
        await load(userId: uid)
    }
}

