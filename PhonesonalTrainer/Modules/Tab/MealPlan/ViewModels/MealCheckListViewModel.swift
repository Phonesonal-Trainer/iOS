//
//  MealCheckListViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/23/25.
//

/// 체크박스의 선택 상태를 관리
/// 식단 플랜 섹션의 리스트 부분에서 사용
import Foundation

enum CompleteStatus: String, Codable {
    case complete = "COMPLETE"
    case incomplete = "INCOMPLETE"
}

struct PatchCompleteRequest: Encodable {
    let foodId: Int
    let date: String
    let mealTime: String
    let complete: String
}

final class MealCheckListViewModel: ObservableObject {
    @Published var selectedMealIDs: Set<UUID> = []   // UI 선택표시(로컬)
    @Published var inFlight: Set<Int> = []           // 패치 진행중 foodId
    @Published var errorMessage: String?

    // 초기 체크표시 상태 세팅 (API의 isComplete 기반)
    func syncSelection(from items: [MealModel]) {
        selectedMealIDs = Set(items.filter { $0.isComplete }.map { $0.id })
    }

    func isSelected(_ meal: MealModel) -> Bool {
        selectedMealIDs.contains(meal.id)
    }

    // 토글 + PATCH
    func toggle(meal: MealModel, date: Date, mealType: MealType, token: String? = nil) async {
        let willSelect = !isSelected(meal)
        // 낙관적 업데이트
        if willSelect { selectedMealIDs.insert(meal.id) } else { selectedMealIDs.remove(meal.id) }
        inFlight.insert(meal.foodId)

        do {
            try await patchComplete(
                foodId: meal.foodId,
                date: DateFormatter.dateOnly.string(from: date),
                mealType: mealType,
                status: willSelect ? .complete : .incomplete,
                token: token
            )
        } catch {
            // 실패 → 롤백
            if willSelect { selectedMealIDs.remove(meal.id) } else { selectedMealIDs.insert(meal.id) }
            errorMessage = "상태 저장 실패: \(error.localizedDescription)"
        }

        inFlight.remove(meal.foodId)
    }

    private func patchComplete(foodId: Int, date: String, mealType: MealType,
                               status: CompleteStatus, token: String?) async throws {
        let url = URL(string: "http://43.203.60.2:8080/foods/plans/complete")!
        var req = URLRequest(url: url)
        req.httpMethod = "PATCH"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token { req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }

        let body = PatchCompleteRequest(
            foodId: foodId, date: date, mealTime: mealType.rawValue, complete: status.rawValue
        )
        req.httpBody = try JSONEncoder().encode(body)

        _ = try await URLSession.shared.data(for: req)  // 필요하면 응답 디코딩 추가
    }
}
