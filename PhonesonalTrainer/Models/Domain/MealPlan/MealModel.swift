//
//  MealModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/15/25.
//

import Foundation

struct MealModel : Identifiable {
    let id : UUID
    let name : String    // ex) "소고기"
    let amount : Int     // ex) "180g"
    let kcal : Double?      // ex) "321kcal"
    let imageURL : String    // 이미지가 url로 오겠지..?  근데 더미데이터로 프리뷰 볼 땐 이미지 이름으로 해야할듯..
    
    init(id: UUID = UUID(), name: String, amount: Int, kcal: Double? = nil, imageURL: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.kcal = kcal
        self.imageURL = imageURL
    }
    
    init(name: String, amount: Int, kcal: Double? = nil, imageURL: String) {
        self.init(id: UUID(), name: name, amount: amount, kcal: kcal, imageURL: imageURL)
    }
    
}
