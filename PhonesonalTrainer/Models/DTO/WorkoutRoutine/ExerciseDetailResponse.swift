//
//  ExerciseDetailResponse.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/7/25.
//

import Foundation

struct ExerciseDetailResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ExerciseDetail   // 배열이 아니라 단일 객체
}

/// 운동 상세 정보
struct ExerciseDetail: Decodable {
    let exerciseId: Int
    let name: String
    let imageUrl: String
    let youtubeUrl: String
    let caution: String
    let bodyPart: [BodyPart]
    let descriptions: [ExerciseDescription]
    
    
}

/// 운동 상세 부위 정보 (근육들)
struct BodyPart: Decodable {
    let id: Int
    let nameEn: String
    let nameKo: String
    let bodyCategory: BodyCategory
}

// 설명 정보
struct ExerciseDescription: Decodable, Identifiable {
    let step: Int
    let main: String
    let sub: String
    
    var id: Int { step }
}
