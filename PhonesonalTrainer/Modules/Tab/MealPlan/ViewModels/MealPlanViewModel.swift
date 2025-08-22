//
//  MealPlanViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/18/25.
//

import Foundation
import SwiftUI

@MainActor
class MealPlanViewModel: ObservableObject {
    @Published var selectedDate: Date = .now
    @Published var selectedType: MealType = .breakfast
    @Published var items: [NutrientInfoModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var plannedTotalKcal: Double = 0
    @Published var actualTotalKcal: Double = 0

    private let service: FoodServiceType
    init(service: FoodServiceType = FoodService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let dateString = DateFormatter.dateOnly.string(from: selectedDate)

        do {
            let res = try await service.fetchNutritionSummary(
                date: dateString,
                token: nil  // 서비스가 addAuthToken() 쓰므로 nil 고정
            )
            // 합계 칼로리 세팅
            self.plannedTotalKcal = res.plannedTotalCalorie
            self.actualTotalKcal  = res.actualTotalCalorie
            
            items = mapToUI(res)
        } catch {
            print("❌ 식단 플랜 API 실패: \(error)")
            print("🔄 더미 데이터로 대체")
            
            // 더미 데이터로 대체
            let dummyData = DummyData.nutritionSummary
            self.plannedTotalKcal = dummyData.plannedTotalCalorie
            self.actualTotalKcal = dummyData.actualTotalCalorie
            items = mapToUI(dummyData)
            
            // 에러 메시지 제거
            errorMessage = nil
        }
    }

    private func mapToUI(_ res: NutritionSummaryResponse) -> [NutrientInfoModel] {
        [
            .init(mealType: "아침",  from: res.summary.breakfast),
            .init(mealType: "점심",  from: res.summary.lunch),
            .init(mealType: "간식",  from: res.summary.snack),
            .init(mealType: "저녁",  from: res.summary.dinner)
        ]
    }

    func state(for type: MealType) -> MealRecordState {
        guard let item = item(for: type) else { return .none }
        switch item.status {
        case .none: return .none
        case .noImage: return .noImage
        case .withImage: return .withImage
        }
    }

    func item(for type: MealType) -> NutrientInfoModel? {
        let key = label(for: type)
        return items.first { $0.mealType == key }
    }

    private func label(for type: MealType) -> String {
        switch type {
        case .breakfast: return "아침"
        case .lunch:     return "점심"
        case .snack:     return "간식"
        case .dinner:    return "저녁"
        }
    }
}
