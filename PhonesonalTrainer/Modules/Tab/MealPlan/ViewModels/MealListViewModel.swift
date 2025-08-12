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
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(FoodPlansResponse.self, from: data)

            self.mealItems = decoded.result.map {
                MealModel(
                    name: $0.foodName,
                    amount: $0.quantity,
                    kcal: nil,                       // 서버에 없으므로 nil
                    imageURL: $0.imageUrl ?? ""
                )
            }
        } catch {
            self.errorMessage = "불러오기 실패: \(error.localizedDescription)"
            self.mealItems = []
        }
    }
}
