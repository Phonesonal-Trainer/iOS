//
//  MealCheckListViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/23/25.
//

/// 체크박스의 선택 상태를 관리
/// 1. 식단 플랜 섹션의 리스트 부분에서 사용
/// 2. FoodCard에서도 사용
import Foundation

class MealCheckListViewModel: ObservableObject {
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
}
