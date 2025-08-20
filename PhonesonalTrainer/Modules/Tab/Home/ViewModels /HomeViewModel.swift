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
            print("❌ 홈 데이터 로드 실패: \(error.localizedDescription)")
            
            // 에러 타입에 따른 처리
            if let nsError = error as NSError? {
                switch nsError.code {
                case 500:
                    self.errorText = "서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
                case 401, 403:
                    self.errorText = "인증이 만료되었습니다. 다시 로그인해주세요."
                    // 인증 만료 시 온보딩 화면으로 이동
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                    }
                case -1:
                    self.errorText = "데이터를 불러올 수 없습니다. 네트워크를 확인해주세요."
                default:
                    self.errorText = "홈 데이터 로드 실패: \(error.localizedDescription)"
                }
            } else {
                self.errorText = "홈 데이터 로드 실패: \(error.localizedDescription)"
            }
            
            // 기본값으로 UI 초기화 (앱 크래시 방지)
            self.userId = 0
            self.targetCalories = 2000
            self.todayCalories = 0
            self.targetWeight = 60
            self.comment = "데이터를 불러오는 중입니다..."
            self.presentWeek = 1
            self.dateString = DateFormatter().string(from: Date())
            self.koreanDate = ""
            
            // 운동 데이터 기본값
            self.todayBurnedCalories = 0
            self.todayRecommendBurnedCalories = 300
            self.anaerobicExerciseTime = 0
            self.aerobicExerciseTime = 0
            self.exercisePercentage = 0
            self.focusedBodyPart = "전신"
            self.exerciseStatus = "대기"
            
            // 식단 데이터 기본값
            self.todayRecommendedCalories = 2000
            self.todayConsumedCalorie = 0
            self.carb = 0
            self.protein = 0
            self.fat = 0
            self.caloriePercentage = 0
            self.calorieStatus = "대기"
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

