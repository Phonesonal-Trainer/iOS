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
    
    // MARK: - 운동 추천 생성 API - RecommendationAPI 사용
    func generateRecommendations() async -> Bool {
        return await RecommendationAPI.generateExerciseRecommendation()
    }

    // MARK: - API 연동
    func loadWorkouts(for date: Date) {
        Task {
            await loadWorkoutsWithRetry(for: date, retryCount: 1)
        }
    }
    
    private func loadWorkoutsWithRetry(for date: Date, retryCount: Int) async {
        do {
            let dateString = DateFormatter.dateOnly.string(from: date)
            guard var urlComponents = URLComponents(string: "http://43.203.60.2:8080/exercise/userExercises") else { return }
            urlComponents.queryItems = [URLQueryItem(name: "exerciseDate", value: dateString)]
            guard let url = urlComponents.url else { return }
            
            var req = URLRequest(url: url)
            req.addAuthToken()

            let (data, response) = try await URLSession.shared.data(for: req)
            
            // HTTP 상태 코드 및 응답 형식 확인
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 400 {
                    // 401/403 에러인 경우 토큰 갱신 시도
                    if (httpResponse.statusCode == 401 || httpResponse.statusCode == 403) && retryCount > 0 {
                        print("🔄 운동 API 인증 에러 - 토큰 갱신 시도")
                        if await AuthAPI.refreshToken() {
                            print("🔄 토큰 갱신 성공 - 운동 API 재시도")
                            await loadWorkoutsWithRetry(for: date, retryCount: retryCount - 1)
                            return
                        } else {
                            print("❌ 토큰 갱신 실패 - 재로그인 필요")
                            // 토큰 클리어
                            UserDefaults.standard.removeObject(forKey: "accessToken")
                            UserDefaults.standard.removeObject(forKey: "refreshToken")
                            UserDefaults.standard.removeObject(forKey: "authToken")
                            UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
                            return
                        }
                    }
                    
                    print("❌ 운동 API HTTP \(httpResponse.statusCode) 에러")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("📡 에러 응답: \(responseString)")
                    }
                    return
                }
            }
            
            // 응답이 HTML인지 확인
            if let responseString = String(data: data, encoding: .utf8),
               responseString.trimmingCharacters(in: .whitespaces).hasPrefix("<") {
                print("⚠️ 운동 API 응답이 HTML → 인증 문제")
                return
            }
                
            // JSON 파싱 시도
            do {
                let decoded = try JSONDecoder().decode(UserExerciseResponse.self, from: data)
                let exercises = decoded.result.userExercises ?? []
                
                if exercises.isEmpty {
                    print("🔄 운동 데이터가 비어있음 - 더미 데이터 사용")
                    await loadDummyWorkouts()
                    return
                }
                
                var resultModels: [WorkoutModel] = []
                
                try await withThrowingTaskGroup(of: WorkoutModel?.self) { group in
                    for userExercise in exercises {
                        group.addTask {
                            do {
                                let detail = try await self.fetchExerciseDetail(id: userExercise.exerciseId)
                                return WorkoutModel(userExercise: userExercise, exerciseDetail: detail)
                            } catch {
                                print("❌ ExerciseDetail 실패: \(error)")
                                // 상세 정보 실패 시 기본 더미 데이터 사용
                                return WorkoutModel(
                                    userExercise: userExercise,
                                    exerciseDetail: DummyData.exerciseDetail
                                )
                            }
                        }
                    }
                    
                    for try await model in group {
                        if let model = model { resultModels.append(model) }
                    }
                }
                
                await MainActor.run {
                    self.workouts = resultModels
                }
                
            } catch {
                print("❌ 운동 API JSON 파싱 실패: \(error)")
                print("🔄 더미 데이터로 대체")
                await loadDummyWorkouts()
            }
        } catch {
            print("❌ 운동 불러오기 실패: \(error)")
            print("🔄 더미 데이터로 대체")
            await loadDummyWorkouts()
        }
    }
    
    // MARK: - 더미 운동 데이터 로드
    private func loadDummyWorkouts() async {
        print("🔄 더미 운동 데이터 로드 시작")
        
        var resultModels: [WorkoutModel] = []
        
        for userExercise in DummyData.userExercises {
            let workoutModel = WorkoutModel(
                userExercise: userExercise,
                exerciseDetail: DummyData.exerciseDetail
            )
            resultModels.append(workoutModel)
        }
        
        await MainActor.run {
            self.workouts = resultModels
        }
        
        print("✅ 더미 운동 데이터 로드 완료: \(resultModels.count)개")
    }
    
    // 카드 돋보기 클릭 시 항상 API 호출
    func showDetail(for workout: WorkoutModel) {
        Task {
            do {
                let apiDetail = try await fetchExerciseDetail(id: workout.exerciseId)
                self.activeDetail = WorkoutDetailModel(from: apiDetail)
            } catch {
                print("❌ 상세 불러오기 실패: \(error)")
            }
        }
    }

    // 실제 상세 API
    func fetchExerciseDetail(id: Int) async throws -> ExerciseDetail {

        guard let url = URL(string: "http://43.203.60.2:8080/exercises/\(id)") else {
            throw URLError(.badURL)
        }
        
        var req = URLRequest(url: url)
        req.addAuthToken()

        let (data, _) = try await URLSession.shared.data(for: req)
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
                req.addAuthToken()
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
