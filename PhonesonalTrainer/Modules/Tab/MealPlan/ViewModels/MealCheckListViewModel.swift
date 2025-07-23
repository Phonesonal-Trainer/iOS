//
//  MealCheckListViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/23/25.
//

/// 체크박스의 선택 상태를 관리
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
}
