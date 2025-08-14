//
//  FoodService.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/14/25.
//

import Foundation

final class FoodService: FoodServiceType {
    // MARK: - POST /foods/{foodId}/favorite
    func toggleFavorite(foodId: Int, token: String? = nil) async throws -> Bool {
        let url = URL(string: "http://43.203.60.2:8080/foods/\(foodId)/favorite")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        if let token { req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse).map({ (200...299).contains($0.statusCode) }) == true else {
            let msg = (try? JSONDecoder().decode(ToggleFavoriteResponse.self, from: data).message) ?? "즐겨찾기 변경 실패"
            throw NSError(domain: "FavToggle", code: 1, userInfo: [NSLocalizedDescriptionKey: msg])
        }
        return try JSONDecoder().decode(ToggleFavoriteResponse.self, from: data).result.favorite
    }
    
    // MARK: - GET /foods/search
    func searchFoods(keyword: String, sort: SortType?, token: String? = nil) async throws -> [MealModel] {
        var comps = URLComponents(string: "http://43.203.60.2:8080/foods/search")!
        let kw = keyword.trimmingCharacters(in: .whitespaces)
        comps.queryItems = [.init(name: "keyword", value: kw.isEmpty ? "" : kw)]
        if let sort { comps.queryItems?.append(sort.asQueryItem()) }
        
        guard let url = comps.url else { throw URLError(.badURL) }
        var req = URLRequest(url: url)
        if let token { req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") } // 필요 시

        let (data, resp) = try await URLSession.shared.data(for: req)
        let status = (resp as? HTTPURLResponse)?.statusCode ?? -1
        guard (200...299).contains(status) else {
            // 서버에서 에러 메시지를 message에 담아줄 수 있으니 시도
            let msg = (try? JSONDecoder().decode(FoodSearchResponse.self, from: data).message) ?? "식단 검색 실패"
            throw NSError(domain: "FoodSearch", code: status, userInfo: [NSLocalizedDescriptionKey: msg])
        }
        
        let decoded = try JSONDecoder().decode(FoodSearchResponse.self, from: data)
        return decoded.result.map(MealModel.init(search:))
    }
    
    // MARK: - POST /foods/user-meals/from-food
    func addUserMealFromFood(foodId: Int, date: Date, mealTime: MealType, token: String? = nil) async throws -> UserMealItem {
        guard let url = URL(string: "http://43.203.60.2:8080/foods/user-meals/from-food") else { throw URLError(.badURL) }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token { req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }

        let body = AddUserMealFromFoodRequest(
            foodId: foodId,
            date: DateFormatter.dateOnly.string(from: date),
            mealTime: mealTime.rawValue
        )
        req.httpBody = try JSONEncoder().encode(body)

        let (data, resp) = try await URLSession.shared.data(for: req)
        let http = resp as? HTTPURLResponse
        guard let statusCode = http?.statusCode, (200...299).contains(statusCode) else {
            let msg = (try? JSONDecoder().decode(AddUserMealFromFoodResponse.self, from: data).message) ?? "추가 실패"
            throw NSError(domain: "AddUserMeal", code: http?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: msg])
        }
        return try JSONDecoder().decode(AddUserMealFromFoodResponse.self, from: data).result
    }
    // MARK: - POST /foods/user-meals/custom
    func addCustomUserMeal(
        name: String,
        calorie: Double,
        carb: Double,
        protein: Double,
        fat: Double,
        date: Date,
        mealTime: MealType,
        token: String? = nil
    ) async throws {
        guard let url = URL(string: "http://43.203.60.2:8080/foods/user-meals/custom") else {
            throw URLError(.badURL)
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token { req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }

        let body = AddCustomUserMealRequest(
            name: name,
            calorie: calorie,
            carb: carb,
            protein: protein,
            fat: fat,
            date: DateFormatter.dateOnly.string(from: date),
            mealTime: mealTime.rawValue
        )
        req.httpBody = try JSONEncoder().encode(body)
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        let status = (resp as? HTTPURLResponse)?.statusCode ?? -1
        guard (200...299).contains(status) else {
            let msg = (try? JSONDecoder().decode(AddCustomUserMealResponse.self, from: data).message) ?? "직접 추가 실패"
            throw NSError(domain: "AddCustomMeal", code: status, userInfo: [NSLocalizedDescriptionKey: msg])
        }
        _ = try? JSONDecoder().decode(AddCustomUserMealResponse.self, from: data) // 성공 시 메시지 확인용(선택)
    }
}
