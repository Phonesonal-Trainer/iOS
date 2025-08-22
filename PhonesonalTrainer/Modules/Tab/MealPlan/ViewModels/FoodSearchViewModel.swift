//
//  FoodSearchViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/24/25.
//

import Foundation
import SwiftUI

@MainActor
class FoodSearchViewModel: ObservableObject {
    // MARK: - Property
    @Published var searchText: String = ""    // 서치바
    @Published var selectedSort: SortType = .frequency    // 정렬
    @Published var currentPage: Int = 1      // 식단 아이템 paging view
    @Published var allFoods: [MealModel] = []
    @Published var selectedMealIDs: Set<UUID> = []   // 사용자가 어떤 식단을 체크했는지 상태 관리
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: FoodServiceType
    private let favorites: FavoritesStore

    init(favorites: FavoritesStore, service: FoodServiceType = FoodService()) {
        self.favorites = favorites
        self.service = service
    }

    // MARK: - 함수
    func toggleSelection(of meal: MealModel) {   // 선택/해제 토글 함수
        if selectedMealIDs.contains(meal.id) {
            selectedMealIDs.remove(meal.id)
        } else {
            selectedMealIDs.insert(meal.id)
        }
    }
    
    func isSelected(_ meal: MealModel) -> Bool {
            selectedMealIDs.contains(meal.id)
    }
    
    // 그리드에 사용
    let itemsPerPage = 8
    
    // 즐겨찾기 순 정렬
    var filteredFoods: [MealModel] {
        // 기본 정렬(빈도)
        var base = (selectedSort == .frequency) ? allFoods : allFoods
        // 즐겨찾기 순일 때는 favorite 먼저 오도록 정렬/필터
        if selectedSort == .favorite {
            base = allFoods
                .filter { favorites.contains($0.foodId) }   // 즐겨찾기만 보여주려면 필터
                .sorted { $0.name < $1.name }    // 2차 정렬 기준(원하는대로)
        }
        return searchText.isEmpty ? base : base.filter { $0.name.contains(searchText) }
    }
    
    var pagedFoods: [MealModel] {
        let start = (currentPage - 1) * itemsPerPage
        let end = min(start + itemsPerPage, filteredFoods.count)
        guard start < end else { return [] }
        return Array(filteredFoods[start..<end])
    }
    
    var totalPages: Int {
        max(1, Int(ceil(Double(filteredFoods.count) / Double(itemsPerPage))))
    }

    func goToPreviousPage() {
        if currentPage > 1 {
            currentPage -= 1
        }
    }

    func goToNextPage() {
        if currentPage < totalPages {
            currentPage += 1
        }
    }

    func selectSort(_ sort: SortType) {
        selectedSort = sort
        currentPage = 1 // 페이지 초기화 -> out of range 방지용
    }
    
    // 검색
    func fetchFoods(token: String? = nil) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let foods = try await service.searchFoods(keyword: searchText, sort: selectedSort, token: token)
            self.allFoods = foods
            self.currentPage = 1
        } catch {
            print("❌ 식단 검색 API 실패: \(error)")
            print("🔄 더미 데이터로 대체")
            
            // 더미 데이터로 대체
            self.allFoods = DummyData.searchFoods
            self.currentPage = 1
            self.errorMessage = nil
        }
    }

    // 저장 (다건 선택 → 개별 POST)
    func saveSelected(date: Date, mealType: MealType, token: String? = nil) async throws {
        let targets = allFoods.filter { selectedMealIDs.contains($0.id) }
        guard !targets.isEmpty else { return }

        try await withThrowingTaskGroup(of: Void.self) { group in
            for m in targets {
                group.addTask { _ = try await self.service.addUserMealFromFood(foodId: m.foodId, date: date, mealTime: mealType, token: token) }
            }
            try await group.waitForAll()
        }

        NotificationCenter.default.post(name: .userMealsDidChange, object: nil)
    }
}
