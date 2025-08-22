//  MyPageViewModel.swift
//  PhonesonalTrainer

import Foundation
import SwiftUI
import UIKit   // ✅ UIImage 쓰려면 꼭 필요

@MainActor
final class MyPageViewModel: ObservableObject {
    // UI 상태
    @Published var isLoading: Bool = false
    @Published var errorText: String? = nil
    @Published var isOffline: Bool = false   // 폴백 사용 여부
    
    // ✅ 아바타 (이미지 + 편의 메서드)
    @Published var avatarImage: UIImage? = nil
    func setAvatar(_ image: UIImage?) {
        self.avatarImage = image
    }

    // 헤더
    @Published var name: String = "회원님"
    @Published var goalText: String = "목표 체중 60kg"
    @Published var durationText: String = "3주차"

    // 주차 진행
    @Published var signUpDate: Date = Date().addingTimeInterval(-60*60*24*21) // 3주 전
    @Published var targetWeeks: Int = 12

    // 목표 카드용 모델
    @Published var goalData: GoalStatsData = .init(
        weight: .init(current: 66.6, goal: 60.0),
        bodyFat: .init(current: 24.0, goal: 20.0),
        muscle: .init(current: 29.0, goal: 31.0),
        bmi: .init(current: 23.4, goal: 21.0)
    )

    // GoalView로 넘기는 상세 데이터
    @Published var recommend: RecommendGoalDTO = .init()
    @Published var workout: WorkoutGoalDTO = .init()
    @Published var meal: MealGoalDTO = .init()

    // 앱 처음 띄울 때 더미를 먼저 깔고 시작 → 화면 빈 상태 방지
    init() {
        applyDummy()
    }

    func applyDummy() {
        isOffline = true
        errorText = nil
    }

    /// API 호출 시도 → 실패하면 더미 유지 + 에러 배너만 표시
    func load() async {
        isLoading = true
        errorText = nil
        defer { isLoading = false }

        do {
            // TODO: 실제 API 호출 코드로 교체
            // let result = try await ApiClient.fetchMyPage(userId: ...)
            // self.bind(result)

        } catch {
            // 실패 → 더미 유지 + 에러 문구만 올려주기
            self.isOffline = true
            self.errorText = "서버 연결에 실패했습니다. 더미 데이터로 표시 중이에요."
        }
    }
}

// ===== Dummy DTO들 =====
struct RecommendGoalDTO { init() {} }
struct WorkoutGoalDTO { init() {} }
struct MealGoalDTO { init() {} }
