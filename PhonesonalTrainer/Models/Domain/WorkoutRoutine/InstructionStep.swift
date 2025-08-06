//
//  InstructionStep.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/6/25.
//

import Foundation

struct InstructionStep: Identifiable, Decodable {
    let id : UUID
    let workoutID: UUID
    let step: Int
    let title: String
    let description: String?
    // youtube url도 추가
}
