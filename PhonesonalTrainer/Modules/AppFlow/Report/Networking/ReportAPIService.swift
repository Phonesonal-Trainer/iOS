//
//  ReportAPIService.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 2025-01-25.
//

import Foundation
import Alamofire

// MARK: - Protocol
protocol ReportAPIServicing {
    func fetchWeight(week: Int) async throws -> WeightReportDTO
    func fetchExercise(week: Int) async throws -> ExerciseReportDTO
    func fetchExerciseStamp(week: Int) async throws -> ExerciseStampResult
    func fetchFoods(week: Int) async throws -> FoodsReportDTO
}

// MARK: - Implementation
final class ReportAPIService: ReportAPIServicing {
    private let baseURL = "http://43.203.60.2:8080"
    private let accessTokenProvider: () -> String?
    
    init(accessTokenProvider: @escaping () -> String? = { 
        UserDefaults.standard.string(forKey: "accessToken") 
    }) {
        self.accessTokenProvider = accessTokenProvider
    }
    
    func fetchWeight(week: Int) async throws -> WeightReportDTO {
        let endpoint = "\(baseURL)/report/weight"
        let parameters = ["week": week]
        let headers = createHeaders()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, 
                      method: .get, 
                      parameters: parameters, 
                      headers: headers)
                .validate()
                .responseDecodable(of: APIEnvelope<WeightReportDTO>.self) { response in
                    switch response.result {
                    case .success(let envelope):
                        continuation.resume(returning: envelope.result)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchExercise(week: Int) async throws -> ExerciseReportDTO {
        let endpoint = "\(baseURL)/report/exercise"
        let parameters = ["week": week]
        let headers = createHeaders()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, 
                      method: .get, 
                      parameters: parameters, 
                      headers: headers)
                .validate()
                .responseDecodable(of: APIEnvelope<ExerciseReportDTO>.self) { response in
                    switch response.result {
                    case .success(let envelope):
                        continuation.resume(returning: envelope.result)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchExerciseStamp(week: Int) async throws -> ExerciseStampResult {
        let endpoint = "\(baseURL)/report/exercise/stamp"
        let parameters = ["week": week]
        let headers = createHeaders()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, 
                      method: .get, 
                      parameters: parameters, 
                      headers: headers)
                .validate()
                .responseDecodable(of: APIEnvelope<ExerciseStampResult>.self) { response in
                    switch response.result {
                    case .success(let envelope):
                        continuation.resume(returning: envelope.result)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func fetchFoods(week: Int) async throws -> FoodsReportDTO {
        let endpoint = "\(baseURL)/report/foods"
        let parameters = ["week": week]
        let headers = createHeaders()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint, 
                      method: .get, 
                      parameters: parameters, 
                      headers: headers)
                .validate()
                .responseDecodable(of: APIEnvelope<FoodsReportDTO>.self) { response in
                    switch response.result {
                    case .success(let envelope):
                        continuation.resume(returning: envelope.result)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    private func createHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = ["Accept": "application/json"]
        
        if let token = accessTokenProvider(), !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
}
