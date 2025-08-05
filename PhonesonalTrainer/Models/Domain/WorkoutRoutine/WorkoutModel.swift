//
//  WorkoutModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/2/25.
//

import Foundation

enum WorkoutStatus: String {
    case inProgress = "진행중"
    case done = "완료"
    case recorded = "기록된 운동"
}

/// 나중에 운동 정보 더 추가.. 뭐 소모 칼로리 이런거
struct WorkoutModel: Identifiable {
    let id: UUID
    let name: String
    let bodyPart: String
    let muscleGroups: [String]  // 여러 개 일 수 있으니까
    let category: WorkoutType  // 무산소, 유산소
    var status: WorkoutStatus
    let imageURL : String  // 운동 상세 보기할 때 보이는 이미지
    var kcalBurned: Double? = nil   // 기록한 운동에서 가져오는 칼로리 소모량
    
    init(id: UUID = UUID(), name: String, bodyPart: String, muscleGroups: [String] = [], category: WorkoutType, status: WorkoutStatus, imageURL: String, kcalBurned: Double? = nil) {
        self.id = id
        self.name = name
        self.bodyPart = bodyPart
        self.muscleGroups = muscleGroups
        self.category = category
        self.status = status
        self.imageURL = imageURL
        self.kcalBurned = kcalBurned
    }
    
    init(name: String, bodyPart: String, muscleGroups: [String] = [], category: WorkoutType, status: WorkoutStatus, imageURL: String) {
        self.init(id: UUID(), name: name, bodyPart: bodyPart, muscleGroups: muscleGroups, category: category, status: status, imageURL: imageURL)
    }
}
