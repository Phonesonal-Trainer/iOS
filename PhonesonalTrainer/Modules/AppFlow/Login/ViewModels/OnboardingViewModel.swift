//
//  OnboardingViewModel.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//

import Foundation
import Combine
import SwiftUI



final class OnboardingViewModel: ObservableObject {

    // ✅ 서버 응답용 유저 모델
    @Published var user: User = .empty

    // ✅ 텍스트 입력 바인딩용 (사용자가 입력한 값)
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var bodyFat: String = ""
    @Published var muscleMass: String = ""
    @Published var nickname: String = ""
    @Published var age: Int = 0
    @Published var gender: String = "" // 예: "MALE" or "FEMALE"
    @Published var purpose: String = "" // 예: "벌크업", "체중감량" 등
    @Published var deadline: Int = 0 // 예: 30, 60 등 기간 일 수
    @Published var tempToken: String = ""
    @Published var bodyFatRate: String = ""
    
    // ✅ API 상태 관리
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var signupResponse: SignupResponse?
    @Published var diagnosisResult: DiagnosisInputModel?
    @Published var isDiagnosisLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()



    // ✅ 진단 요청 모델 생성
    func toDiagnosisModel() -> DiagnosisInputModel {
        let heightDouble = Double(height) ?? 0
        let weightDouble = Double(weight) ?? 0
        let bodyFatDouble = Double(bodyFat)
        let muscleMassDouble = Double(muscleMass)

        // 임시 MetricChange 모델 생성 (실제로는 진단 로직 필요)
        let weightChange = MetricChange(before: "\(weightDouble)", after: "\(weightDouble)", diff: nil)
        let bmiChange = MetricChange(before: "0", after: "0", diff: nil)
        let bodyFatChange = bodyFatDouble != nil ? MetricChange(before: "\(bodyFatDouble!)", after: "\(bodyFatDouble!)", diff: nil) : nil
        let muscleMassChange = muscleMassDouble != nil ? MetricChange(before: "\(muscleMassDouble!)", after: "\(muscleMassDouble!)", diff: nil) : nil

        return DiagnosisInputModel(
            weightChange: weightChange,
            bmiChange: bmiChange,
            bodyFatChange: bodyFatChange,
            muscleMassChange: muscleMassChange,
            comment: "임시 진단 코멘트입니다.",
            exerciseGoals: [],
            dietGoals: []
        )
    }
    
    // MARK: - Helper Functions
    private func convertGenderToEnglish(_ koreanGender: String) -> String {
        switch koreanGender {
        case "남성", "남자", "Male", "male":
            return "MALE"
        case "여성", "여자", "Female", "female":
            return "FEMALE"
        default:
            return "MALE" // 기본값
        }
    }
    
    private func convertPurposeToEnglish(_ koreanPurpose: String) -> String {
        switch koreanPurpose {
        case "벌크업", "근육량 증가", "muscle gain":
            return "벌크업"
        case "체중감량", "다이어트", "weight loss":
            return "체중감량"
        case "체중유지", "유지", "maintain":
            return "체중유지"
        default:
            return "체중감량" // 기본값
        }
    }
    
    // ✅ 회원가입 API 호출
    func signup(completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        // accessToken이 있으면 기존 사용자로 간주하고 전체 프로필 업데이트 수행
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"), !accessToken.isEmpty {
            print("✅ 이미 로그인된 상태 - 전체 프로필 업데이트 수행 (진단을 위해 필요)")
            Task {
                await self.updateExistingUserProfile()
                // 전체 프로필을 AuthAPI.signup으로 서버에 저장 (진단 API를 위해 필요)
                await self.callAuthAPISignupForExistingUser()
                await MainActor.run {
                    self.isLoading = false
                    completion(true) // 항상 성공으로 처리하여 진단 단계로 진행
                }
            }
            return
        }
        
        // tempToken이 비어있거나 기본값이면 회원가입 시도하지 않음
        guard !tempToken.isEmpty && tempToken != "temp_token_default" else {
            print("❌ 유효한 tempToken이 없어서 회원가입 불가")
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "로그인이 필요합니다."
                completion(false)
            }
            return
        }
        
        let request = SignupRequest(
            tempToken: tempToken,
            nickname: nickname.isEmpty ? "사용자" : nickname,
            age: age > 0 ? age : 25,
            gender: convertGenderToEnglish(gender),
            purpose: convertPurposeToEnglish(purpose),
            deadline: deadline > 0 ? deadline : 30,
            height: Double(height) ?? 170.0,
            weight: Double(weight) ?? 70.0,
            bodyFatRate: bodyFat.isEmpty ? nil : Double(bodyFat),
            muscleMass: muscleMass.isEmpty ? nil : Double(muscleMass)
        )
        
        // 📋 Request 객체 상세 출력
        print("📋 ===== SIGNUP REQUEST =====")
        print("📋 tempToken: \(request.tempToken)")
        print("📋 nickname: \(request.nickname)")
        print("📋 age: \(request.age)")
        print("📋 gender: \(request.gender) (원본: \(gender))")
        print("📋 purpose: \(request.purpose) (원본: \(purpose))")
        print("📋 deadline: \(request.deadline)")
        print("📋 height: \(request.height)")
        print("📋 weight: \(request.weight)")
        print("📋 bodyFatRate: \(request.bodyFatRate?.description ?? "nil")")
        print("📋 muscleMass: \(request.muscleMass?.description ?? "nil")")
        print("📋 ==========================")
        
        AuthAPI.shared.signup(request: request)
            .sink(
                receiveCompletion: { [weak self] completionResult in
                    self?.isLoading = false
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        completion(false)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.signupResponse = response
                    if response.isSuccess, let result = response.result {
                        // 토큰 저장 (필요시 KeyChain이나 UserDefaults 사용)
                        UserDefaults.standard.set(result.accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(result.refreshToken, forKey: "refreshToken")
                        completion(true)
                    } else if response.code == "INVALID_TEMP_TOKEN" {
                        // 임시 해결책: OAuth2 완료된 상태에서 INVALID_TEMP_TOKEN이면 성공으로 처리
                        print("⚡ 임시 해결책: OAuth2 완료 상태이므로 성공으로 처리")
                        completion(true)
                    } else {
                        self?.errorMessage = response.message
                        completion(false)
                    }
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - 기존 사용자 프로필 갱신 (닉네임/키/몸무게)
    private func updateExistingUserProfile() async -> Bool {
        var allSucceeded = true

        // 닉네임 갱신
        if !nickname.trimmingCharacters(in: .whitespaces).isEmpty {
            do {
                let _: APIResponse<String> = try await APIClient.shared.patch(
                    path: "/mypage/nickname",
                    queryItems: [URLQueryItem(name: "nickname", value: nickname)]
                )
                print("✅ 닉네임 갱신 완료: \(nickname)")
            } catch {
                print("❌ 닉네임 갱신 실패: \(error.localizedDescription)")
                allSucceeded = false
            }
        }

        // 키 갱신 (정수 cm)
        if let hDouble = Double(height), hDouble > 0 {
            let h = Int(hDouble.rounded())
            do {
                let _: APIResponse<String> = try await APIClient.shared.patch(
                    path: "/mypage/height",
                    queryItems: [URLQueryItem(name: "height", value: String(h))]
                )
                print("✅ 키 갱신 완료: \(h)cm")
            } catch {
                print("❌ 키 갱신 실패: \(error.localizedDescription)")
                allSucceeded = false
            }
        }

        // 몸무게 갱신 (홈 API로 기록) - 실패해도 온보딩 진행을 막지 않음
        if let w = Double(weight), w > 0 {
            let userId = UserDefaults.standard.integer(forKey: "userId")
            if userId != 0 {
                do {
                    try await WeightAPI.update(userId: userId, weight: w)
                    print("✅ 몸무게 갱신 완료: \(w)")
                } catch {
                    // 서버 측 오류(예: GoalPeriod null 등)는 비치명적 처리
                    print("❌ 몸무게 갱신 실패(비치명적): \(error.localizedDescription)")
                }
            } else {
                print("⚠️ userId 없음으로 몸무게 갱신 생략(비치명적)")
            }
        }

        // TODO: 성별/나이/목적/기간/체지방/골격근량 갱신 엔드포인트가 제공되면 여기서 추가 호출

        return allSucceeded
    }
    
    // ✅ 기존 사용자를 위한 전체 프로필 저장 (진단 API를 위해 필요)
    @MainActor
    private func callAuthAPISignupForExistingUser() async {
        // tempToken이 없으므로 빈 문자열 또는 "existing_user" 처리
        let request = SignupRequest(
            tempToken: "existing_user_profile_update",
            nickname: nickname.isEmpty ? "사용자" : nickname,
            age: age > 0 ? age : 25,
            gender: convertGenderToEnglish(gender),
            purpose: convertPurposeToEnglish(purpose),
            deadline: deadline > 0 ? deadline : 30,
            height: Double(height) ?? 170.0,
            weight: Double(weight) ?? 70.0,
            bodyFatRate: bodyFat.isEmpty ? nil : Double(bodyFat),
            muscleMass: muscleMass.isEmpty ? nil : Double(muscleMass)
        )
        
        print("📋 ===== 기존 사용자 전체 프로필 업데이트 =====")
        print("📋 nickname: \(request.nickname)")
        print("📋 age: \(request.age)")
        print("📋 gender: \(request.gender)")
        print("📋 purpose: \(request.purpose)")
        print("📋 deadline: \(request.deadline)")
        print("📋 height: \(request.height)")
        print("📋 weight: \(request.weight)")
        print("📋 bodyFatRate: \(request.bodyFatRate?.description ?? "nil")")
        print("📋 muscleMass: \(request.muscleMass?.description ?? "nil")")
        print("📋 ===============================================")
        
        do {
            let response = try await withCheckedThrowingContinuation { continuation in
                AuthAPI.shared.signup(request: request)
                    .sink(
                        receiveCompletion: { completionResult in
                            switch completionResult {
                            case .finished:
                                break
                            case .failure(let error):
                                continuation.resume(throwing: error)
                            }
                        },
                        receiveValue: { response in
                            continuation.resume(returning: response)
                        }
                    )
                    .store(in: &cancellables)
            }
            
            if response.isSuccess {
                print("✅ 기존 사용자 전체 프로필 저장 성공 - 진단 API 호출 준비 완료")
            } else {
                print("⚠️ 기존 사용자 프로필 저장 실패하지만 진단 시도: \(response.message)")
            }
        } catch {
            print("⚠️ 기존 사용자 프로필 저장 에러하지만 진단 시도: \(error.localizedDescription)")
        }
    }
    
    // ✅ 진단 API 호출
    func fetchDiagnosis(completion: @escaping (Bool) -> Void) {
        isDiagnosisLoading = true
        errorMessage = nil
        
        // API 엔드포인트 - 진단 목표 API
        guard let url = URL(string: "http://43.203.60.2:8080/diagnosis/goals") else {
            print("❌ 진단 API URL 생성 실패")
            isDiagnosisLoading = false
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Authorization 헤더 추가하되 새로운 데이터 사용 강제 플래그 추가
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("🔑 Authorization 헤더 추가: Bearer \(accessToken)")
        } else {
            print("⚠️ accessToken이 없어서 Authorization 헤더 미추가")
        }
        
        // 사용자 입력 데이터를 포함한 진단 요청 본문 생성
        let diagnosisRequestBody: [String: Any] = [
            "nickname": nickname.isEmpty ? "사용자" : nickname,
            "age": age > 0 ? age : 25,
            "gender": convertGenderToEnglish(gender),
            "purpose": convertPurposeToEnglish(purpose),
            "deadline": deadline > 0 ? deadline : 30,
            "height": Double(height) ?? 170.0,
            "weight": Double(weight) ?? 70.0,
            "bodyFatRate": bodyFat.isEmpty ? nil : Double(bodyFat),
            "targetMuscleMass": muscleMass.isEmpty ? nil : muscleMass
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: diagnosisRequestBody, options: [])
            request.httpBody = jsonData
            
            print("🚀 진단 API 요청 시작 (사용자 데이터 포함)")
            print("🚀 URL: \(url)")
            print("🚀 Request Body: \(String(data: jsonData, encoding: .utf8) ?? "인코딩 실패")")
            print("🔍 Authentication Test: Bearer token = \(UserDefaults.standard.string(forKey: "accessToken") ?? "없음")")
        } catch {
            print("❌ 진단 요청 JSON 인코딩 실패: \(error)")
            isDiagnosisLoading = false
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isDiagnosisLoading = false
                
                if let error = error {
                    print("❌ 진단 API 네트워크 오류: \(error)")
                    self?.errorMessage = "네트워크 오류가 발생했습니다."
                    completion(false)
                    return
                }
                
                // HTML 응답 가드 추가
                if let httpResponse = response as? HTTPURLResponse,
                   let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"),
                   contentType.contains("text/html") {
                    print("⚠️ 진단 API 응답이 HTML → 인증 문제 또는 잘못된 엔드포인트")
                    self?.errorMessage = "인증이 필요합니다."
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("❌ 진단 API 응답 데이터 없음")
                    self?.errorMessage = "서버 응답이 없습니다."
                    completion(false)
                    return
                }
                
                // 응답 로깅
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📡 진단 API 응답: \(responseString)")
                }
                
                do {
                    let diagnosisResponse = try JSONDecoder().decode(DiagnosisResponse.self, from: data)
                    
                    if diagnosisResponse.isSuccess {
                        print("✅ 진단 API 성공")
                        self?.diagnosisResult = diagnosisResponse.result.toDiagnosisInputModel()
                        completion(true)
                    } else {
                        print("❌ 진단 API 실패: \(diagnosisResponse.message)")
                        self?.errorMessage = diagnosisResponse.message
                        completion(false)
                    }
                } catch {
                    print("❌ 진단 API JSON 파싱 실패: \(error)")
                    self?.errorMessage = "서버 응답을 처리할 수 없습니다."
                    completion(false)
                }
            }
        }.resume()
    }
    
    // ✅ 운동 추천 생성 API 호출
    func generateExerciseRecommendation(completion: @escaping (Bool) -> Void) {
        // API 엔드포인트
        guard let url = URL(string: "http://43.203.60.2:8080/exercises-recommandtion/generate") else {
            print("❌ 운동 추천 API URL 생성 실패")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Authorization 헤더 추가
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("🔑 운동 추천 API Authorization 헤더 추가: Bearer \(accessToken)")
        } else {
            print("⚠️ accessToken이 없어서 Authorization 헤더 미추가")
        }
        
        print("🚀 운동 추천 API 요청 시작")
        print("🚀 URL: \(url)")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ 운동 추천 API 네트워크 에러: \(error)")
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("❌ 운동 추천 API 데이터 없음")
                    completion(false)
                    return
                }
                
                // HTTP 상태 코드 확인
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode >= 400 {
                        print("❌ 운동 추천 API HTTP \(httpResponse.statusCode) 에러")
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("📡 에러 응답: \(responseString)")
                        }
                        completion(false)
                        return
                    }
                }
                
                // 응답이 HTML인지 확인
                if let responseString = String(data: data, encoding: .utf8),
                   responseString.trimmingCharacters(in: .whitespaces).hasPrefix("<") {
                    print("⚠️ 운동 추천 API 응답이 HTML → 인증 문제")
                    completion(false)
                    return
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📡 운동 추천 API 응답: \(responseString)")
                }
                
                do {
                    let exerciseResponse = try JSONDecoder().decode(ExerciseRecommendationResponse.self, from: data)
                    
                    if exerciseResponse.isSuccess {
                        print("✅ 운동 추천 API 성공: \(exerciseResponse.result)")
                        completion(true)
                    } else {
                        print("❌ 운동 추천 API 실패: \(exerciseResponse.message)")
                        completion(false)
                    }
                } catch {
                    print("❌ 운동 추천 API JSON 파싱 실패: \(error)")
                    completion(false)
                }
            }
        }.resume()
    }
}
