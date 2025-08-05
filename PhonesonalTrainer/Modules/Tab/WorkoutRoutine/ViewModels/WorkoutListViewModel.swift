//
//  WorkoutListViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/4/25.
//

import Foundation

class WorkoutListViewModel: ObservableObject {
    @Published var workouts: [WorkoutModel] = [
        WorkoutModel(name: "힙 쓰러스트", bodyPart: "하체", muscleGroups: [], category: .anaerobic, status: .inProgress, imageURL: ""),
        WorkoutModel(name: "힙 쓰러스트", bodyPart: "하체", muscleGroups: [], category: .anaerobic, status: .done, imageURL: ""),
        WorkoutModel(name: "힙 쓰러스트", bodyPart: "하체", muscleGroups: [], category: .aerobic, status: .inProgress, imageURL: ""),
        WorkoutModel(name: "힙 쓰러스트", bodyPart: "하체", muscleGroups: [], category: .aerobic, status: .recorded, imageURL: "", kcalBurned: 123),
        WorkoutModel(name: "레그 프레스", bodyPart: "하체", muscleGroups: ["대퇴사두근", "햄스트링", "둔근"], category: .anaerobic, status: .inProgress, imageURL: "")
    ]
    
    @Published var selectedTab: WorkoutTab = .all
    
    /// Segment에 따라 '전체', '진행중', '완료' 보여주기
    var filteredWorkouts: [WorkoutType: [WorkoutModel]] {
        let filtered: [WorkoutModel]
        switch selectedTab {
        case .all:
            filtered = workouts
        case .inProgress:
            filtered = workouts.filter { $0.status == .inProgress }
        case .completed:
            filtered = workouts.filter { $0.status == .done || $0.status == .recorded }
        }
        /// 리스트에서 '무산소', '유산소'로 나눠서 나열
        return Dictionary(grouping: filtered, by: { $0.category })
    }
    
    /// 직접 추가한 운동에서 칼로리 소모량 가져오기
    func addRecordedWorkout(name: String, category: WorkoutType, kcal: Double) {
        let newWorkout = WorkoutModel(
            name: name,
            bodyPart: "", // 직접입력 시 비워도 됨
            muscleGroups: [],
            category: category,
            status: .recorded,
            imageURL: "",
            kcalBurned: kcal
        )
        workouts.append(newWorkout)
    }
}

enum WorkoutTab: String, CaseIterable, Identifiable {
    case all = "전체"
    case inProgress = "진행중"
    case completed = "완료"
    
    var id: String { rawValue }
}
