//
//  InstructionStep.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/6/25.
//

import Foundation

// 시트에 바로 바인딩 가능
struct WorkoutDetailModel: Identifiable {
    let id: Int                 // exerciseId
    let name: String
    let bodyCategory: BodyCategory    // 첫 bodyPart의 카테고리(예: "가슴")
    let bodyParts: [String]     // 근육들 (Ko)
    let imageURL: URL?
    let youtubeURL: URL?
    let caution: String
    let descriptions: [ExerciseDescription] // (step, main, sub) 그대로 사용

    init(from detail: ExerciseDetail) {
        self.id = detail.exerciseId
        self.name = detail.name
        self.bodyCategory = detail.bodyPart.first?.bodyCategory ?? .unknown
        self.bodyParts = detail.bodyPart.map { $0.nameKo }
        self.imageURL = URL(string: detail.imageUrl)
        self.youtubeURL = URL(string: detail.youtubeUrl)
        self.caution = detail.caution
        self.descriptions = detail.descriptions.sorted { $0.step < $1.step }
    }
}
