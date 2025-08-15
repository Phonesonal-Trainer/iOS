//
//  AuthService.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//


import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}

    func signup(with viewModel: OnboardingViewModel, tempToken: String, completion: @escaping (Result<SignupResponse, Error>) -> Void) {
        var components = URLComponents(string: "http://43.203.60.2:8080/Authentication/signup")!
        components.queryItems = [
            URLQueryItem(name: "tempToken", value: tempToken),
            URLQueryItem(name: "nickname", value: viewModel.nickname),
            URLQueryItem(name: "age", value: String(viewModel.age)),
            URLQueryItem(name: "gender", value: viewModel.gender),
            URLQueryItem(name: "purpose", value: viewModel.purpose),
            URLQueryItem(name: "deadline", value: String(viewModel.deadline)),
            URLQueryItem(name: "height", value: String(viewModel.height)),
            URLQueryItem(name: "weight", value: String(viewModel.weight)),
            URLQueryItem(name: "bodyFatRate", value: String(viewModel.bodyFatRate)),
            URLQueryItem(name: "muscleMass", value: String(viewModel.muscleMass))
        ]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -2)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(SignupResponse.self, from: data)
                
                // ✅ accessToken 저장 (optional 처리)
                if let result = decoded.result {
                    UserDefaults.standard.set(result.accessToken, forKey: "authToken")
                    UserDefaults.standard.set(result.refreshToken, forKey: "refreshToken")
                }

                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
