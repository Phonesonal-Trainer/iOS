//
//  WorkoutSearchViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/2/25.
//

import Foundation
import SwiftUI

class WorkoutSearchViewModel: ObservableObject {
    @Published var searchText: String = ""    // 서치바
    @Published var currentPage: Int = 1      // 운동 아이템 paging view
    
    // @Published var workout: [WorkoutModel] = []  // API에서 받아올 예정. -> 배열에 저장
    @Published var selectedWorkoutIDs: Set<UUID> = []   // 사용자가 어떤 식단을 체크했는지 상태 관리
    
    func toggleSelection(of workout: WorkoutModel) {   // 선택/해제 토글 함수
        if selectedWorkoutIDs.contains(workout.id) {
            selectedWorkoutIDs.remove(workout.id)
        } else {
            selectedWorkoutIDs.insert(workout.id)
        }
    }
    
    func isSelected(_ workout: WorkoutModel) -> Bool {
            selectedWorkoutIDs.contains(workout.id)
    }
    
    // 그리드에 사용
    let itemsPerPage = 8
    
    // 추후에 백엔드와 연결시 allWorkouts를 API 호출 결과로 대체.
    @Published var allWorkouts: [WorkoutModel] = [
        WorkoutModel(name: "레그 익스텐션", bodyPart: "하체", muscleGroups: ["대퇴사두근"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "레그 컬", bodyPart: "하체", muscleGroups: ["햄스트링"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "힙 쓰러스트", bodyPart: "하체", muscleGroups: ["대둔근", "햄스트링", "중둔근", "코어"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "렛풀다운", bodyPart: "상체", muscleGroups: ["광배근"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "풀업", bodyPart: "상체", muscleGroups: ["광배근"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "시티드 로우", bodyPart: "상체", muscleGroups: ["광배근", "능형근", "척추기립근"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "바벨 스쿼트", bodyPart: "하체", muscleGroups: ["대퇴사두근", "햄스트링", "대둔근"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "덤벨 스쿼트", bodyPart: "하체", muscleGroups: ["대퇴사두근", "대둔근", "햄스트링"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "런지", bodyPart: "하체", muscleGroups: ["대퇴사두근", "대둔근", "햄스트링"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "벤치프레스", bodyPart: "상체", muscleGroups: ["대흉근", "상완삼두근", "전면 삼각근"], category: .anaerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "런닝머신", bodyPart: "하체", muscleGroups: [], category: .aerobic, status: .recorded, imageURL: ""),
        WorkoutModel(name: "천국의 계단", bodyPart: "하체", muscleGroups: [], category: .aerobic, status: .recorded, imageURL: "")
    ]
    
    var filteredWorkouts: [WorkoutModel] {
        guard !searchText.isEmpty else { return allWorkouts }
        return allWorkouts.filter { $0.name.contains(searchText) }
        
    }
    
    var pagedWorkouts: [WorkoutModel] {
        let start = (currentPage - 1) * itemsPerPage
        let end = min(start + itemsPerPage, filteredWorkouts.count)
        guard start < end else { return [] }
        return Array(filteredWorkouts[start..<end])
    }
    
    var totalPages: Int {
        max(1, Int(ceil(Double(filteredWorkouts.count) / Double(itemsPerPage))))
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
}
