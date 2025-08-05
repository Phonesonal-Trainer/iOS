//
//  FoodSearchViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/24/25.
//

import Foundation
import SwiftUI

class FoodSearchViewModel: ObservableObject {
    @Published var searchText: String = ""    // 서치바
    @Published var selectedSort: SortType = .frequency    // 정렬
    @Published var currentPage: Int = 1      // 식단 아이템 paging view
    
    @Published var meals: [MealModel] = []  // API에서 받아올 예정. -> 배열에 저장
    @Published var selectedMealIDs: Set<UUID> = []   // 사용자가 어떤 식단을 체크했는지 상태 관리

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
    
    // 추후에 백엔드와 연결시 allFoods를 API 호출 결과로 대체.
    @Published var allFoods: [MealModel] = [
        MealModel(name: "닭가슴살", amount: 100, kcal: 110, imageURL: "temp_image"),
        MealModel(name: "삶은 달걀", amount: 50, kcal: 68, imageURL: "temp_image"),
        MealModel(name: "토마토", amount: 100, kcal: 14, imageURL: "temp_image"),
        MealModel(name: "방울토마토", amount: 13, kcal: 2, imageURL: "temp_image"),
        MealModel(name: "바나나", amount: 100, kcal: 93, imageURL: "temp_image"),
        MealModel(name: "야채샐러드", amount: 150, kcal: 148, imageURL: "temp_image"),
        MealModel(name: "사과", amount: 150, kcal: 57, imageURL: "temp_image"),
        MealModel(name: "블루베리", amount: 28, kcal: 16, imageURL: "temp_image"),
        MealModel(name: "단백질바", amount: 50, kcal: 249, imageURL: "temp_image"),
        MealModel(name: "포케", amount: 230, kcal: 221, imageURL: "temp_image"),
        MealModel(name: "스테비아방울토마토", amount: 15, kcal: 6.8, imageURL: "temp_image"),
        MealModel(name: "찐고구마", amount: 200, kcal: 277, imageURL: "temp_image"),
        MealModel(name: "계란 프라이", amount: 46, kcal: 89, imageURL: "temp_image"),
        MealModel(name: "토마토 스파게티", amount: 200, kcal: 370, imageURL: "temp_image"),
        MealModel(name: "단백질 쉐이크", amount: 30, kcal: 110, imageURL: "temp_image"),
        MealModel(name: "아몬드", amount: 6, kcal: 40, imageURL: "temp_image")
    ]
    
    var filteredFoods: [MealModel] {
        let sorted = selectedSort == .frequency ? allFoods : allFoods.reversed() // 예시
        if searchText.isEmpty {
            return sorted
        } else {
            return sorted.filter { $0.name.contains(searchText) }
        }
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
}
