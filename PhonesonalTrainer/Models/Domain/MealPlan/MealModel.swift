//
//  MealModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/15/25.
//

import Foundation

struct MealModel : Identifiable {
    let id : UUID = UUID()
    let name : String    // ex) "소고기"
    let amount : Int     // ex) "180g"
    let kcal : Int      // ex) "321kcal"
    let imageURL : String    // 이미지가 url로 오겠지..?  근데 더미데이터로 프리뷰 볼 땐 이미지 이름으로 해야할듯..
}
