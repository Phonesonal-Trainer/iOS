//
//  WorkoutTimerService.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/19/25.
//

import Foundation

// MARK: - 공통 응답 래퍼
struct WorkoutAPIEnvelope<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}

// MARK: - 상세 DTO (스키마 그대로)
typealias UserExerciseDetailDTO = UserExercise // 이미 동일 필드로 정의해둔 구조 재사용

// MARK: - 타이머 API 서비스
final class WorkoutTimerService {
    static let shared = WorkoutTimerService()
    private init() {}
    private let base = URL(string: "http://43.203.60.2:8080")!

    /// 유저 운동 시작
    func startUserExercise(userExerciseId: Int) async throws -> UserExerciseDetailDTO {
        var req = URLRequest(url: base.appending(path: "/exercise/userExercises/\(userExerciseId)/start"))
        req.httpMethod = "PATCH"
        req.addAuthToken()

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(WorkoutAPIEnvelope<UserExerciseDetailDTO>.self, from: data)
        return decoded.result
    }

    /// 세트 완료
    func completeSet(userExerciseId: Int, setId: Int) async throws -> UserExerciseDetailDTO {
        var req = URLRequest(url: base.appending(path: "/exercise/userExercises/\(userExerciseId)/sets/\(setId)/complete"))
        req.httpMethod = "PATCH"
        req.addAuthToken()

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(WorkoutAPIEnvelope<UserExerciseDetailDTO>.self, from: data)
        return decoded.result
    }

    /// 다음 세트 시작(휴식 후)
    func startNextSet(userExerciseId: Int) async throws -> UserExerciseDetailDTO {
        var req = URLRequest(url: base.appending(path: "/exercise/userExercises/\(userExerciseId)/next-set"))
        req.httpMethod = "PATCH"
        req.addAuthToken()

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(WorkoutAPIEnvelope<UserExerciseDetailDTO>.self, from: data)
        return decoded.result
    }

    /// 유저 운동 완료
    func completeUserExercise(userExerciseId: Int) async throws -> UserExerciseDetailDTO {
        var req = URLRequest(url: base.appending(path: "/exercise/userExercises/\(userExerciseId)/complete"))
        req.httpMethod = "PATCH"
        req.addAuthToken()

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(WorkoutAPIEnvelope<UserExerciseDetailDTO>.self, from: data)
        return decoded.result
    }
}
