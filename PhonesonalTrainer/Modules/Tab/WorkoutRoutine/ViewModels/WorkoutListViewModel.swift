//
//  WorkoutListViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/4/25.
//

import Foundation

@MainActor
class WorkoutListViewModel: ObservableObject {
    // 서버에서 받아온 + 직접 추가한 운동을 모두 저장
    @Published var workouts: [WorkoutModel] = []
    // 선택된 세그먼트 탭 (전체 / 진행중 / 완료)
    @Published var selectedTab: WorkoutTab = .all
    // 시트 프리젠테이션 상태
    @Published var activeDetail: WorkoutDetailModel? = nil

    // MARK: - Segment 필터 + 운동 유형별 그룹화
    var filteredWorkouts: [WorkoutType: [WorkoutModel]] {
        let filtered: [WorkoutModel]
        switch selectedTab {
        case .all:
            filtered = workouts
        case .inProgress:
            filtered = workouts.filter { $0.status == .inProgress }
        case .completed:
            filtered = workouts.filter { $0.status == .done || $0.status == .recorded }
        }
        return Dictionary(grouping: filtered, by: { $0.category })
    }

    // MARK: - API 연동
    func loadWorkouts(for date: Date) {
        Task {
            do {
                let dateString = DateFormatter.dateOnly.string(from: date)
                guard var urlComponents = URLComponents(string: "http://43.203.60.2:8080/exercise/userExercises") else { return }
                urlComponents.queryItems = [URLQueryItem(name: "exerciseDate", value: dateString)]
                guard let url = urlComponents.url else { return }

                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(UserExerciseResponse.self, from: data)

                var resultModels: [WorkoutModel] = []

                try await withThrowingTaskGroup(of: WorkoutModel?.self) { group in
                    for userExercise in decoded.result {
                        group.addTask {
                            do {
                                let detail = try await self.fetchExerciseDetail(id: userExercise.exerciseId)
                                
                                return WorkoutModel(
                                    userExercise: userExercise,
                                    exerciseDetail: detail
                                )
                            } catch {
                                print("❌ ExerciseDetail 실패: \(error)")
                                return nil
                            }
                        }
                    }
                    
                    for try await model in group {
                        if let model = model { resultModels.append(model) }
                    }
                }
                // 기존 운동들 초기화 후 새로 설정
                self.workouts = resultModels
            } catch {
                print("❌ 운동 불러오기 실패: \(error)")
            }
        }
    }
    
    // 카드 돋보기 클릭 시 항상 API 호출
    func showDetail(for workout: WorkoutModel) {
        Task {
            do {
                let apiDetail = try await fetchExerciseDetail(id: workout.exerciseId)
                activeDetail = WorkoutDetailModel(from: apiDetail)
            } catch {
                print("❌ 상세 불러오기 실패: \(error)")
            }
        }
    }

    // 실제 상세 API
    private func fetchExerciseDetail(id: Int) async throws -> ExerciseDetail {

        guard let url = URL(string: "http://43.203.60.2:8080/exercises/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(ExerciseDetailResponse.self, from: data)

        guard decoded.isSuccess else {
            throw NSError(domain: "API Error", code: -1, userInfo: [NSLocalizedDescriptionKey: decoded.message])
        }

        return decoded.result
    }

    // MARK: - 직접 추가한 운동 기록
    func addRecordedWorkout(name: String, category: WorkoutType, kcal: Double?) {
        Task {
            do {
                let body = CreateCustomUserExerciseRequest(
                    exerciseName: name,
                    kcal: kcal ?? 0,
                    exerciseType: category.rawValue
                )
                var req = URLRequest(url: URL(string: "http://43.203.60.2:8080/exercise/userExercise/custom")!)
                req.httpMethod = "POST"
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                req.httpBody = try JSONEncoder().encode(body)

                let (data, resp) = try await URLSession.shared.data(for: req)
                guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else { throw URLError(.badServerResponse) }
                let decoded = try JSONDecoder().decode(CreateCustomUserExerciseResponse.self, from: data)
                let created = decoded.result

                // 상세 있으면 시도 → 실패해도 fallback append
                let model: WorkoutModel
                if created.exerciseId != 0, let detail = try? await fetchExerciseDetail(id: created.exerciseId) {
                    model = WorkoutModel(userExercise: created, exerciseDetail: detail)
                } else {
                    model = WorkoutModel(
                        id: created.userExerciseId,
                        exerciseId: created.exerciseId,
                        name: created.exerciseName,
                        bodyPart: .unknown,
                        muscleGroups: [],
                        category: WorkoutType(rawValue: created.exerciseType) ?? category,
                            status: .recorded,
                            kcalBurned: created.caloriesBurned,
                            exerciseSets: []
                    )
                }
                self.workouts.append(model)      // 로컬 반영으로 끝 (재조회 X)

            } catch {
                print("❌ 직접 추가 저장 실패:", error)
            }
        }
    }
}
