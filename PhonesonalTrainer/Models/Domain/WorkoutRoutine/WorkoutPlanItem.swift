//
//  WorkoutPlanItem.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import Foundation

struct WorkoutPlanItem: Identifiable, Hashable {
    let id: Int                 // userExerciseId
    let exerciseId: Int
    let name: String
    let type: WorkoutType       // .anaerobic / .cardio
    let totalSets: Int
    let targetReps: Int         // 무산소 기준 세트 타깃(없으면 15로 디폴트)
    let defaultWeight: Int      // 무산소용(없으면 0)
    let setIds: [Int]           // 서버 세트 id들

    init(model: WorkoutModel) {
        self.id = model.id
        self.exerciseId = model.exerciseId
        self.name = model.name
        self.type = model.category

        // 세트 수: 서버가 내려준 exerciseSets 개수, 최소 1
        let setsCount = max(1, model.exerciseSets.count)
        self.totalSets = setsCount

        // reps/weight: 첫 세트 기준으로 추정 (필드명이 다르면 맞춰 바꿔 주세요)
        // ExerciseSet에 reps/targetReps/weight 같은 필드가 있을 거라 가정
        let first = model.exerciseSets.first
        self.targetReps = max(1, first?.count ??  15)
        self.defaultWeight = max(0, first?.weight ?? 0)
        self.setIds = model.exerciseSets.map { $0.setId }
    }
}
