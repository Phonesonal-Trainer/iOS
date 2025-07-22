//
//  MealRecordState.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/21/25.
//

import Foundation

/// 식단 기록의 상태 ( 기록 X, 기록 O 이미지 X, 기록과 이미지 O ) 관리
enum MealRecordState {
    case none
    case noImage
    case withImage
}
