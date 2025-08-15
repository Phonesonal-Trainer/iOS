//
//  SearchWorkoutModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/12/25.
//

import Foundation

struct SearchWorkoutModel: Identifiable, Hashable {
    let id: Int               // = exerciseId
    let name: String
    let bodyPart: BodyCategory
    let category: WorkoutType // .aerobic / .anaerobic
}

extension SearchWorkoutModel {
    init(dto: ExerciseItemDTO) {
        self.id = dto.exerciseId
        self.name = dto.name
        self.bodyPart = dto.bodyPart.first?.bodyCategory ?? .unknown
        self.category = (dto.type == "aerobic") ? .aerobic : .anaerobic
    }
}
