//
//  MealModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/15/25.
//

import Foundation

struct MealModel : Identifiable, Hashable, Codable {
    var id = UUID()
    let foodId: Int
    let name : String    // ex) "소고기"
    let amount : Int     // ex) "180g"
    let kcal : Double?      // ex) "321kcal"
    let imageURL : String
    var isComplete : Bool
    
    // ⬇️ 추가
    var carb: Double? = nil     // g
    var protein: Double? = nil  // g
    var fat: Double? = nil      // g
    
    init(id: UUID = UUID(), foodId: Int, name: String, amount: Int, kcal: Double? = nil, imageURL: String, isComplete: Bool = false, carb: Double? = nil, protein: Double? = nil, fat: Double? = nil) {
        self.id = id
        self.foodId = foodId
        self.name = name
        self.amount = amount
        self.kcal = kcal
        self.imageURL = imageURL
        self.isComplete = isComplete
        self.carb = carb
        self.protein = protein
        self.fat = fat
    }
    // 이게 필요할까..?
    // init(foodId: Int, name: String, amount: Int, kcal: Double? = nil, imageURL: String, isComplete: Bool ) {
    //     self.init(id: Int, foodId: foodId, name: name, amount: amount, kcal: kcal, imageURL: imageURL, isComplete: isComplete)
    // }
}

extension MealModel {
    init(api: FoodPlanItem) {
        self.id = UUID()
        self.foodId = api.foodId
        self.name = api.foodName
        self.amount = api.quantity
        self.kcal = api.calories
        self.imageURL = api.imageUrl ?? ""
        self.isComplete = (api.complete == "COMPLETE")
       
    }
}

extension MealModel {
    // ✅ GET /foods/search 결과 → 앱 모델
    init(search dto: FoodSearchItem) {
        self.id = UUID()
        self.foodId = dto.foodId
        self.name = dto.name
        // "180g" 같은 문자열에서 숫자만 뽑아 Int로(서버가 "180g"처럼 줄 수도 있어 보여서 안전하게 처리)
        let num = Int(dto.servingSize.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)) ?? 0
        self.amount = num
        self.kcal = dto.calorie
        self.imageURL = dto.imageUrl ?? ""
        self.isComplete = false
        
    
    }
}
    
