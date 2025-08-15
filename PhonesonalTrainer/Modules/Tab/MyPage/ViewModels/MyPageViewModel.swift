//  MyPageViewModel.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/15/25.
//

import SwiftUI
import Foundation

@MainActor
final class MyPageViewModel: ObservableObject {
    // 헤더
    @Published var name: String = "회원님"
    @Published var durationText: String = "-"     // chip에 들어갈 "3주차"
    @Published var goalText: String = "-"         // "목표 체중 60kg"
    @Published var userId: Int? = {
        let saved = UserDefaults.standard.integer(forKey: "userId")
        return saved == 0 ? nil : saved
    }()
    
    //  프로필 아바타(전역 공유)
    @Published var avatarImage: UIImage? = nil
    private let avatarFileName = "profile_avatar.jpg"
    
    
    // 진행 바
    @Published var signUpDate: Date = Date()
    @Published var targetWeeks: Int = 0
    
    // "내 목표" 카드(MyGoalView)용 데이터
    @Published var goalData: GoalStatsData = .init(
        weight: .init(current: 0, goal: 0),
        bodyFat: .init(current: 0, goal: 0),
        muscle: .init(current: 0, goal: 0),
        bmi: .init(current: 0, goal: 0)
    )
    
    // 자세히 보기 → GoalView에 넘길 데이터
    @Published var recommend: RecommendedGoalsUIModel = .init(
        weightFrom: "-", weightTo: "-", weightDiff: "-",
        bmiFrom: "-", bmiTo: "-", bmiDiff: "-",
        fatFrom: "-", fatTo: "-", fatDiff: "-",
        skeletalTag: "-"
    )
    @Published var workout: WorkoutGoalsUIModel = .init(
        routine: "-", anaerobic: "-", aerobic: "-"
    )
    @Published var meal: MealGoalsUIModel = .init(
        nutrient: "-", amount: "-"
    )
    
    // 상태
    @Published var isLoading = false
    @Published var errorText: String?
    
    
    init() {
        loadAvatarFromDisk()
    }
    
    // MARK: - Avatar I/O
    func setAvatar(_ image: UIImage?) {
        self.avatarImage = image
        if let img = image {
            saveAvatarToDisk(img)
        } else {
            removeAvatarFromDisk()
        }
    }
    
    private func avatarFileURL() -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(avatarFileName)
    }
    private func saveAvatarToDisk(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.9) {
            try? data.write(to: avatarFileURL(), options: .atomic)
        }
    }
    private func loadAvatarFromDisk() {
        let url = avatarFileURL()
        if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
            self.avatarImage = img
        } else {
            self.avatarImage = nil
        }
    }
    private func removeAvatarFromDisk() {
        try? FileManager.default.removeItem(at: avatarFileURL())
    }
    
    
    func load() async {
        isLoading = true
        errorText = nil
        
        // 이전에 저장했던 userId가 있을 경우에만 API 호출 시도
        let uid = UserDefaults.standard.integer(forKey: "userId")
        if uid == 0 {
            self.errorText = "로그인이 필요합니다."
            isLoading = false
            
            // 🚨 중요: 로그인 상태가 아닐 때 더미 데이터 할당
            self.name = "회원님"
            self.durationText = "0주차"
            self.goalText = "목표 체중 -- kg"
            self.signUpDate = Date()
            self.targetWeeks = 1
            self.goalData = GoalStatsData(
                weight: .init(current: 0, goal: 0),
                bodyFat: .init(current: 0, goal: 0),
                muscle: .init(current: 0, goal: 0),
                bmi: .init(current: 0, goal: 0)
            )
            self.recommend = RecommendedGoalsUIModel(
                weightFrom: "-- kg", weightTo: "-- kg", weightDiff: "-- kg",
                bmiFrom: "--", bmiTo: "--", bmiDiff: "--",
                fatFrom: "--%", fatTo: "--%", fatDiff: "--%p",
                skeletalTag: "-"
            )
            self.workout = WorkoutGoalsUIModel(
                routine: "-", anaerobic: "-", aerobic: "-"
            )
            self.meal = MealGoalsUIModel(
                nutrient: "-", amount: "-"
            )
            return
        }
        
        do {
            // 두 API 병렬 호출
            async let home = MyPageAPI.fetchMyPageHome()
            async let target = MyPageAPI.fetchTarget()
            let (h, t) = try await (home, target)
            
            // 포맷터
            func num(_ v: Double?, d: Int = 1) -> String {
                guard let v = v else { return "-" }
                let f = NumberFormatter()
                f.minimumFractionDigits = 0
                f.maximumFractionDigits = d
                return f.string(from: NSNumber(value: v)) ?? "\(v)"
            }
            func diff(from: Double?, to: Double?, unit: String, d: Int = 1) -> String {
                guard let f = from, let t = to else { return "-" }
                let dv = t - f
                let sign = dv > 0 ? "+" : (dv < 0 ? "-" : "")
                let absV = abs(dv)
                return "\(sign)\(num(absV, d: d))\(unit)"
            }
            
            // 1) 헤더
            let together = h.togetherWeeks ?? 0
            name = h.nickname ?? "회원님"
            durationText = "\(together)주차"
            goalText = "목표 체중 \(num(t.targetWeight)) kg"
            
            // 2) 진행 바 (signupDate가 없으니 주차를 역산)
            let days = together * 7
            signUpDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
            targetWeeks = h.targetWeeks ?? 0
            
            // 3) "내 목표" 카드 값 (현재 vs 목표)
            let currentWeight = h.weight ?? 0
            let currentFat = h.bodyFatRate ?? 0
            let currentMuscle = h.muscleMass?.value ?? 0
            let currentBMI = h.bmi ?? 0
            
            goalData = GoalStatsData(
                weight: .init(current: currentWeight, goal: t.targetWeight),
                bodyFat: .init(current: currentFat, goal: t.targetedBodyFatRate),
                muscle: .init(current: currentMuscle, goal: t.targetMuscleMass),
                bmi: .init(current: currentBMI, goal: t.targetBMI)
            )
            
            // 4) 자세히 보기(추천 목표 상세)용 모델
            recommend = RecommendedGoalsUIModel(
                weightFrom: "\(num(currentWeight)) kg",
                weightTo: "\(num(t.targetWeight)) kg",
                weightDiff: diff(from: currentWeight, to: t.targetWeight, unit: "kg"),
                bmiFrom: num(currentBMI, d: 1),
                bmiTo: num(t.targetBMI, d: 1),
                bmiDiff: diff(from: currentBMI, to: t.targetBMI, unit: "", d: 1),
                fatFrom: "\(num(currentFat, d: 1))%",
                fatTo: "\(num(t.targetedBodyFatRate, d: 1))%",
                fatDiff: diff(from: currentFat, to: t.targetedBodyFatRate, unit: "%p", d: 1),
                skeletalTag: "<유지 또는 소폭 증가>"
            )
            
            // 5) 운동/식단 요약(문구형)
            workout = WorkoutGoalsUIModel(
                routine: "주 \(t.workoutFrequency)회",
                anaerobic: "주 \(t.strengthTrainingDays)회 / \(t.strengthTrainingTime)분",
                aerobic: "주 \(t.cardioDaysPerWeek)회 / \(t.cardioMinutesPerWeek)분"
            )
            meal = MealGoalsUIModel(
                nutrient: t.recommendedNutrition,
                amount: "\(t.recommendedCalories) kcal"
            )
            
        } catch {
            // ✅ API 호출 실패 시 실행되는 부분입니다.
            self.errorText = "마이페이지 데이터 로드 실패: \(error.localizedDescription)"
            
            // 🚨 여기에 더미 데이터를 직접 할당하세요.
            self.name = "피트니스 회원"
            self.durationText = "5주차"
            self.goalText = "목표 체중 65kg"
            self.signUpDate = Calendar.current.date(byAdding: .day, value: -35, to: Date()) ?? Date()
            self.targetWeeks = 12
            self.goalData = GoalStatsData(
                weight: .init(current: 70, goal: 65),
                bodyFat: .init(current: 25, goal: 20),
                muscle: .init(current: 30, goal: 32),
                bmi: .init(current: 24.5, goal: 22.0)
            )
            self.recommend = RecommendedGoalsUIModel(
                weightFrom: "70.0 kg", weightTo: "65.0 kg", weightDiff: "-5.0 kg",
                bmiFrom: "24.5", bmiTo: "22.0", bmiDiff: "-2.5",
                fatFrom: "25.0%", fatTo: "20.0%", fatDiff: "-5.0%p",
                skeletalTag: "유지 또는 소폭 증가"
            )
            self.workout = WorkoutGoalsUIModel(
                routine: "주 4회", anaerobic: "주 3회 / 40분", aerobic: "주 4회 / 30분"
            )
            self.meal = MealGoalsUIModel(
                nutrient: "균형잡힌 식단", amount: "1800 kcal"
            )
        }
        isLoading = false
    }
}
