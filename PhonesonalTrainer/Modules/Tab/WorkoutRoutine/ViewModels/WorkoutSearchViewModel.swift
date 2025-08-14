//
//  WorkoutSearchViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/2/25.
//

import Foundation
import SwiftUI

@MainActor
final class WorkoutSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var currentPage: Int = 1
    @Published var allWorkouts: [SearchWorkoutModel] = []
    @Published var selectedExerciseIDs: Set<Int> = []
    @Published var errorMessage: String?

    let itemsPerPage = 8

    var filteredWorkouts: [SearchWorkoutModel] {
        guard !searchText.isEmpty else { return allWorkouts }
        return allWorkouts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    var pagedWorkouts: [SearchWorkoutModel] {
        let start = (currentPage - 1) * itemsPerPage
        let end = min(start + itemsPerPage, filteredWorkouts.count)
        guard start < end else { return [] }
        return Array(filteredWorkouts[start..<end])
    }
    var totalPages: Int {
        max(1, Int(ceil(Double(filteredWorkouts.count) / Double(itemsPerPage))))
    }
    func goToPreviousPage() { if currentPage > 1 { currentPage -= 1 } }
    func goToNextPage() { if currentPage < totalPages { currentPage += 1 } }

    // MARK: - GET /exercises/list
    func loadExercises() {
        Task {
            do {
                guard let url = URL(string: "http://43.203.60.2:8080/exercises/list") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(ExerciseListResponse.self, from: data)
                guard decoded.isSuccess else { throw URLError(.badServerResponse) }
                self.allWorkouts = decoded.result.map(SearchWorkoutModel.init(dto:))
            } catch {
                self.errorMessage = "운동 목록을 불러오지 못했어요."
            }
        }
    }

    func toggleSelection(_ item: SearchWorkoutModel) {
        if selectedExerciseIDs.contains(item.id) { selectedExerciseIDs.remove(item.id) }
        else { selectedExerciseIDs.insert(item.id) }
    }
    func isSelected(_ item: SearchWorkoutModel) -> Bool { selectedExerciseIDs.contains(item.id) }

    // MARK: - POST /exercise/{exerciseId}/userExercise
    func saveSelected(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                try await withThrowingTaskGroup(of: Void.self) { group in
                    for id in selectedExerciseIDs {
                        group.addTask {
                            let url = URL(string: "http://43.203.60.2:8080/exercise/\(id)/userExercise")!
                            var req = URLRequest(url: url)
                            req.httpMethod = "POST"
                            // req.setValue("Bearer ...", forHTTPHeaderField: "Authorization") // 필요 시 로그인 관련된..?
                            _ = try await URLSession.shared.data(for: req)
                        }
                    }
                    try await group.waitForAll()
                }
                completion(true)
            } catch {
                self.errorMessage = "저장 실패. 다시 시도해 주세요."
                completion(false)
            }
        }
    }
}
