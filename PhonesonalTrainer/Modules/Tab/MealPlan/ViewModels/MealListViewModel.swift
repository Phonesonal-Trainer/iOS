//
//  MealListViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/21/25.
//

///  api 받아서 정보 처리.
///  지금은 임시로 더미데이터 사용.

import Foundation

@MainActor
final class MealListViewModel: ObservableObject {
    @Published var mealItems: [MealModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func load(date: Date, mealType: MealType) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let dateString = DateFormatter.dateOnly.string(from: date)

        var comps = URLComponents(string: "http://43.203.60.2:8080/food/plans")!
        comps.queryItems = [
            .init(name: "date", value: dateString),
            .init(name: "mealTime", value: mealType.rawValue)
        ]

        guard let url = comps.url else {
            errorMessage = "유효하지 않은 URL"
            return
        }

        do {
            var req = URLRequest(url: url)
            req.addAuthToken() // ← 여기서 토큰 추가

            let (data, _) = try await URLSession.shared.data(for: req)
            let decoded = try JSONDecoder().decode(FoodPlansResponse.self, from: data)
            self.mealItems = decoded.result.map(MealModel.init(api:))
        } catch {
            print("❌ 식단 목록 API 실패: \(error)")
            print("🔄 더미 데이터로 대체")
            
            // 더미 데이터로 대체
            self.mealItems = DummyData.mealItems
            self.errorMessage = nil
        }
    }
}
