//
//  MealPlanViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/18/25.
//

import Foundation

class MealPlanViewModel: ObservableObject {
    var selectedDate: Date = .now
    // 초기 설정
    @Published var selectedType: MealType = .breakfast
    
    // 식사 종류별 기록 상태를 딕셔너리로 관리
    @Published var mealRecordStates: [MealType: MealRecordState] = [
        .breakfast: .none,
        .lunch: .none,
        .dinner: .none,
        .snack: .none
    ]
    
    func fetchMealRecord(for type: MealType) {
        // 서버 응답 기반으로 처리할 것 (예시로 임시 로직 작성)
        let hasRecord = true // ← 백엔드 응답 결과에 따라
        let hasImage = true // ← 백엔드 응답 결과에 따라
        
        if hasRecord {
            if hasImage {
                mealRecordStates[type] = .withImage
            } else {
                mealRecordStates[type] = .noImage
            }
        } else {
            mealRecordStates[type] = MealRecordState.none
        }
    }
    
    func mealRecordState(for type: MealType) -> MealRecordState {
        return mealRecordStates[type] ?? .none
    }

}
