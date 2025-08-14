//
//  BasicResponse.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/12/25.
//

import Foundation

struct BasicResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}
