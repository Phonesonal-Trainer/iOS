//
//  WorkoutTab.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/8/25.
//

import Foundation

enum WorkoutTab: String, CaseIterable, Identifiable {
    case all = "전체"
    case inProgress = "진행중"
    case completed = "완료"
    
    var id: String { rawValue } 
}
