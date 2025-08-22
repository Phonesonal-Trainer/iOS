//
//  RecommendationAPI.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 8/20/25.
//

import Foundation

// 추천 API 통합 관리 서비스
enum RecommendationAPI {
    private static let baseURL = "http://43.203.60.2:8080"
    
    // MARK: - 운동 추천 생성 API
    static func generateExerciseRecommendation() async -> Bool {
        // 올바른 엔드포인트 사용: /exercise-recommendation/generate
        guard let url = URL(string: "\(baseURL)/exercise-recommendation/generate") else {
            print("❌ 운동 추천 API URL 생성 실패")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Authorization 헤더 추가
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("🔑 운동 추천 API Authorization 헤더 추가")
        } else {
            print("⚠️ accessToken이 없어서 Authorization 헤더 미추가")
        }
        
        print("🚀 운동 추천 API 요청 시작")
        print("🚀 URL: \(url)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // HTTP 상태 코드 확인
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode >= 400 {
                    print("❌ 운동 추천 API HTTP \(httpResponse.statusCode) 에러")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("📡 에러 응답: \(responseString)")
                    }
                    return false
                }
            }
            
            // 응답이 HTML인지 확인
            if let responseString = String(data: data, encoding: .utf8),
               responseString.trimmingCharacters(in: .whitespaces).hasPrefix("<") {
                print("⚠️ 운동 추천 API 응답이 HTML → 인증 문제")
                return false
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📡 운동 추천 API 응답: \(responseString)")
            }
            
            // JSON 응답 파싱 - 두 가지 응답 형식 모두 처리
            do {
                let exerciseResponse = try JSONDecoder().decode(ExerciseRecommendationResponse.self, from: data)
                if exerciseResponse.isSuccess {
                    print("✅ 운동 추천 API 성공: \(exerciseResponse.result)")
                    return true
                } else {
                    print("❌ 운동 추천 API 실패: \(exerciseResponse.message)")
                    return false
                }
            } catch {
                // 첫 번째 형식 실패 시 두 번째 형식 시도
                do {
                    let workoutResponse = try JSONDecoder().decode(GenerateWorkoutRecommendationResponse.self, from: data)
                    if workoutResponse.isSuccess {
                        print("✅ 운동 추천 API 성공 (WorkoutList 형식)")
                        return true
                    } else {
                        print("❌ 운동 추천 API 실패 (WorkoutList 형식)")
                        return false
                    }
                } catch {
                    print("❌ 운동 추천 API 응답 파싱 실패: \(error)")
                    return false
                }
            }
        } catch {
            print("❌ 운동 추천 API 에러: \(error)")
            return false
        }
    }
    

    
    // MARK: - 식단 추천 생성 API
    static func generateDietRecommendation(startDate: Date? = nil) async -> Bool {
        return await DietPlanAPI.generateDietRecommendation(startDate: startDate)
    }
    
    // MARK: - 통합 추천 생성 (운동 + 식단)
    static func generateAllRecommendations(startDate: Date? = nil) async -> (exercise: Bool, diet: Bool) {
        async let exerciseResult = generateExerciseRecommendation()
        async let dietResult = generateDietRecommendation(startDate: startDate)
        
        let (exercise, diet) = await (exerciseResult, dietResult)
        
        print("🏋️ 운동 추천: \(exercise ? "성공" : "실패")")
        print("🍽️ 식단 추천: \(diet ? "성공" : "실패")")
        
        return (exercise: exercise, diet: diet)
    }
}
