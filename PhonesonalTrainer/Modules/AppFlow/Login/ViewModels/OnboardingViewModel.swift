//
//  OnboardingViewModel.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 8/7/25.
//

import Foundation
import Combine



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
        
        // accessToken이 있으면 이미 로그인된 상태이므로 바로 성공 처리
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"), !accessToken.isEmpty {
            print("✅ 이미 로그인된 상태 - 회원가입 건너뛰기")
            DispatchQueue.main.async {
                self.isLoading = false
                completion(true)
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
        
        // 백엔드 API 스펙에 따라 No parameters로 요청
        print("🚀 진단 API 요청 시작 (No parameters)")
        print("🚀 URL: \(url)")
        print("🚀 Request: Empty body")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isDiagnosisLoading = false
                
                if let error = error {
                    print("❌ 진단 API 네트워크 오류: \(error)")
                    self?.errorMessage = "네트워크 오류가 발생했습니다."
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
