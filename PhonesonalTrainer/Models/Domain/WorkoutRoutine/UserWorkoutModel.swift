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

/// 나중에 운동 정보 더 추가.. 뭐 소모 칼로리 이런거, 세트 무게, 운동 시간 이런거도 넣어야 되는데..
struct WorkoutModel: Identifiable {
    let id: Int   // userExerciseId (사용자 운동 id)
    let exerciseId: Int   // 운동 id
    let name: String
    let bodyPart: BodyCategory  // 하체 상체
    let muscleGroups: [String]  // 여러 개 일 수 있으니까
    let category: WorkoutType  // 무산소, 유산소
    var status: WorkoutStatus
    var kcalBurned: Double? = nil   // 기록한 운동에서 가져오는 칼로리 소모량
    
    var exerciseSets: [ExerciseSet] = []
    
    /// 앱 내부에서 모델을 직접 만들 때 쓰는거
    init(id: Int, exerciseId: Int, name: String, bodyPart: BodyCategory, muscleGroups: [String] = [], category: WorkoutType, status: WorkoutStatus, kcalBurned: Double? = nil, exerciseSets: [ExerciseSet] = []) {
        self.id = id
        self.exerciseId = exerciseId
        self.name = name
        self.bodyPart = bodyPart
        self.muscleGroups = muscleGroups
        self.category = category
        self.status = status
        self.kcalBurned = kcalBurned
        self.exerciseSets = exerciseSets
    }
    
   
}

/// 서버에서 받은 데이터를 위한 (디코딩)   ** 내 운동 리스트용**
extension WorkoutModel {
    init(userExercise: UserExercise, exerciseDetail: ExerciseDetail) {
        // category 변환
        let category = WorkoutType(rawValue: userExercise.exerciseType) ?? .anaerobic
        // status 변환
        let status = WorkoutStatus(rawValue: userExercise.state) ?? .inProgress
        
        self.id = userExercise.userExerciseId // userExerciseId(사용자 운동)
        self.exerciseId = userExercise.exerciseId
        self.name = userExercise.exerciseName
        self.bodyPart = exerciseDetail.bodyPart.first?.bodyCategory ?? .unknown  // 이게 맞나
        self.muscleGroups = exerciseDetail.bodyPart.map { $0.nameKo }  // 하 이걸 어떻게 하지..
        self.category = category
        self.status = status
        self.kcalBurned = userExercise.caloriesBurned
        self.exerciseSets = userExercise.exerciseSets
    }
}
