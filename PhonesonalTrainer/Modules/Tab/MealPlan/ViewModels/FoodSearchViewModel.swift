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
    
    let itemsPerPage = 8
    
    // 추후에 백엔드와 연결시 allFoods를 API 호출 결과로 대체.
    @Published var allFoods: [MealModel] = Array(repeating: MealModel(name: "닭가슴살", amount: 100, kcal: 95, imageURL: "temp_image"), count: 18)
    
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
