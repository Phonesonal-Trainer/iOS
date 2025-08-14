//
//  ExerciseListResponse.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/12/25.
//

import Foundation

struct ExerciseListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [ExerciseItemDTO]
}

struct ExerciseItemDTO: Decodable, Identifiable {
    let exerciseId: Int
    let name: String
    let type: String          // "aerobic" | "anaerobic"
    let bodyPart: [ExerciseBodyPartDTO]
    let bookmarked: Bool?
    var id: Int { exerciseId }
}

struct ExerciseBodyPartDTO: Decodable {
    let id: Int
    let nameEn: String
    let nameKo: String
    let bodyCategory: BodyCategory  // "chest" ... ExerciseDetailResponse에 enum으로 선언되어 있음.
}


