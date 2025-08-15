//
//  BodyPhotoResult.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/15/25.
//

// BodyPhotoDTO.swift
import Foundation

struct BodyPhotoResultDTO: Decodable {
    let userId: Int
    let fileName: String
    let filePath: String
}
