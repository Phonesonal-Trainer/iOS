//
//  AddedMealViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/29/25.
//

import Foundation

@MainActor
final class AddedMealViewModel: ObservableObject {
    @Published var addedMeals: [MealRecordEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var deleting: Set<Int> = []   // 진행중 recordId 추적
    @Published var updating: Set<Int> = []   // recordId 진행중 표시
    @Published var favInFlight: Set<Int> = []   // 진행 중 foodId

    
    private var lastQuery: (date: Date, mealType: MealType)? // 재조회용
    
    /// 추가 식단 조회
    func load(date: Date, mealType: MealType, token: String? = nil) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        var comps = URLComponents(string: "http://43.203.60.2:8080/foods/user-meals")!
        comps.queryItems = [
            .init(name: "date", value: DateFormatter.dateOnly.string(from: date)),
            .init(name: "mealTime", value: mealType.rawValue)
        ]
        guard let url = comps.url else { errorMessage = "유효하지 않은 URL"; return }

        do {
            var req = URLRequest(url: url)
            req.addAuthToken()

            let (data, _) = try await URLSession.shared.data(for: req)
            let decoded = try JSONDecoder().decode(UserMealsResponse.self, from: data)
            self.addedMeals = decoded.result.map(MealRecordEntry.init(api:))
        } catch {
            print("❌ 추가 식단 API 실패: \(error)")
            print("🔄 더미 데이터로 대체")
            self.errorMessage = nil // 에러 메시지 숨김
            self.addedMeals = DummyData.userMeals.map(MealRecordEntry.init(api:))
        }
    }

    /// 서버에서 항목 삭제 후 목록에서 제거 (성공 후 제거)
    func deleteMealRemote(_ entry: MealRecordEntry, token: String? = nil) async {
        let recordId = entry.recordId
        guard let url = URL(string: "http://43.203.60.2:8080/foods/user-meals/\(recordId)") else {
            errorMessage = "유효하지 않은 URL"
            return
        }
        
        deleting.insert(recordId)
        defer { deleting.remove(recordId) }
        
        do {
            var req = URLRequest(url: url)
            req.httpMethod = "DELETE"
            req.addAuthToken()

            // 응답 바디는 쓰지 않아도 되지만, 필요하면 BasicResponse로 디코드 가능
            let (data, response) = try await URLSession.shared.data(for: req)
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            if !(200...299).contains(status) {
                // 서버 메시지 파싱 시도
                if let decoded = try? JSONDecoder().decode(BasicResponse.self, from: data) {
                    throw NSError(domain: "DeleteError", code: status, userInfo: [NSLocalizedDescriptionKey: decoded.message])
                } else {
                    throw NSError(domain: "DeleteError", code: status, userInfo: [NSLocalizedDescriptionKey: "삭제 실패( \(status) )"])
                }
            }

            // ✅ 성공 → 로컬 목록에서 제거
            if let idx = addedMeals.firstIndex(where: { $0.recordId == recordId }) {
                addedMeals.remove(at: idx)
            }
        } catch {
            self.errorMessage = "삭제 실패: \(error.localizedDescription)"
        }
    }
    
    /// 양 수정
    func updateQuantity(recordId: Int, quantity: Int, token: String? = nil) async throws {
        guard let url = URL(string: "http://43.203.60.2:8080/foods/user-meals/\(recordId)") else {
            throw NSError(domain: "BadURL", code: -1)
        }
        updating.insert(recordId)
        defer { updating.remove(recordId) }
        
        var req = URLRequest(url: url)
        req.httpMethod = "PATCH"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addAuthToken()
        req.httpBody = try JSONEncoder().encode(UpdateUserMealQuantityRequest(quantity: quantity))

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            if let decoded = try? JSONDecoder().decode(UpdateUserMealQuantityResponse.self, from: data) {
                throw NSError(domain: "PatchFail", code: -2,
                                 userInfo: [NSLocalizedDescriptionKey: decoded.message])
            }
            throw NSError(domain: "PatchFail", code: -2,
                              userInfo: [NSLocalizedDescriptionKey: "수정 실패"])
        }

        // 성공 → 최신 값 반영 위해 재조회
        if let q = lastQuery {
            await load(date: q.date, mealType: q.mealType, token: token)
        }
    }
}
