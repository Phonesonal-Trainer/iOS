//
//  OnboradingDiagnosisView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

struct OnboradingDiagnosisView: View {
    let nickname: String
    let diagnosis: DiagnosisInputModel  // 수정된 모델 사용
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var workoutListVM = WorkoutListViewModel()

    @State private var goToBodyRecord = false
    @State private var isStarting = false
    @State private var showError = false
    
    // ✅ 운동 추천 생성 API 호출 함수
    private func generateExerciseRecommendation(completion: @escaping (Bool) -> Void) {
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
            print("🔑 운동 추천 API Authorization 헤더 추가")
        }
        
        print("🚀 운동 추천 API 요청 시작")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ 운동 추천 API 에러: \(error)")
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
                    print("❌ 운동 추천 API 파싱 실패: \(error)")
                    completion(false)
                }
            }
        }.resume()
    }
    
    private var metrics: [(String, MetricChange)] {
        [
            ("몸무게", diagnosis.weightChange),
            ("BMI", diagnosis.bmiChange),
            ("체지방률", diagnosis.bodyFatChange ?? MetricChange(before: "-", after: "", diff: nil)),
            ("골격근량", diagnosis.muscleMassChange ?? MetricChange(before: "-", after: "", diff: nil))
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.grey00.ignoresSafeArea()

                VStack(spacing: 0) {
                    // 상단 Navigation Bar
                    NavigationBar(title: nil, hasDefaultBackAction: true) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.PretendardMedium22)
                                .foregroundStyle(Color.grey05)
                        }
                    }

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            PageIndicator(totalPages: 4, currentPage: 3, activeColor: .orange05, inactiveColor: .grey01)
                                .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("폰스널 트레이너의 진단")
                                    .font(.PretendardSemiBold24)
                                    .foregroundStyle(Color.grey06)
                                Text("\(nickname)님 맞춤형 진단이에요.")
                                    .font(.PretendardRegular20)
                                    .foregroundStyle(Color.grey03)
                            }
                            .padding(.horizontal)

                            // 진단 코멘트 박스
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Image("피드백아이콘")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                    Text("폰스널 트레이너의 진단")
                                        .font(.PretendardMedium14)
                                        .foregroundStyle(Color.orange05)
                                }
                                Text(diagnosis.comment)
                                    .font(.PretendardMedium12)
                                    .foregroundStyle(Color.grey05)
                                    .padding(.top, 2)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.orange01)
                            .cornerRadius(5)
                            .padding(.horizontal)

                            // 추천 목표 수치
                            VStack(alignment: .leading, spacing: 16) {
                                Text("추천 목표 수치")
                                    .font(.PretendardMedium18)
                                    .foregroundStyle(Color.grey06)

                                VStack(spacing: 16) {
                                    ForEach(Array(metrics.enumerated()), id: \.offset) { index, metric in
                                        MetricRow(title: metric.0, change: metric.1)
                                        if index < metrics.count - 1 { Divider() }
                                    }
                                }
                                .padding(.horizontal, 28)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 16)

                            // 운동 목표
                            VStack(alignment: .leading, spacing: 16) {
                                Text("운동 목표")
                                    .font(.PretendardMedium18)
                                    .foregroundStyle(Color.grey06)

                                ForEach(Array(diagnosis.exerciseGoals.enumerated()), id: \.element.id) { index, goal in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(goal.type)
                                                .font(.PretendardMedium16)
                                                .foregroundStyle(Color.grey05)
                                            Spacer()
                                            Text(goal.mainInfo)
                                                .font(.PretendardMedium16)
                                                .foregroundStyle(Color.grey05)
                                        }
                                        if let detail = goal.detail {
                                            Text(detail)
                                                .font(.PretendardRegular14)
                                                .foregroundStyle(Color.grey03)
                                        }
                                    }
                                    if index < diagnosis.exerciseGoals.count - 1 { Divider() }
                                }
                                .padding(.horizontal, 28)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 16)

                            // 식단 목표
                            VStack(alignment: .leading, spacing: 16) {
                                Text("식단 목표")
                                    .font(.PretendardMedium18)
                                    .foregroundStyle(Color.grey06)

                                ForEach(Array(diagnosis.dietGoals.enumerated()), id: \.element.id) { index, goal in
                                    HStack {
                                        Text(goal.key)
                                            .font(.PretendardMedium16)
                                            .foregroundStyle(Color.grey05)
                                        Spacer()
                                        Text(goal.value)
                                            .font(.PretendardMedium16)
                                            .foregroundStyle(Color.grey05)
                                    }
                                    if index < diagnosis.dietGoals.count - 1 { Divider() }
                                }
                                .padding(.horizontal, 28)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top)
                        .padding(.bottom, 32)
                    }

                    // 시작하기 버튼
                    Button(action: {
                        isStarting = true
                        
                        // 새로운 운동 추천 API 호출 (실패해도 계속 진행)
                        generateExerciseRecommendation { exerciseSuccess in
                            print("🏋️ 운동 추천 API 결과: \(exerciseSuccess ? "성공" : "실패")")
                            
                            Task {
                                // 식단 플랜 생성(기존 유지)
                                let dietSuccess = await DietPlanAPI.generate(startDate: Date())
                                print("🍽️ 식단 플랜 API 결과: \(dietSuccess ? "성공" : "실패")")
                                
                                isStarting = false
                                
                                // API 성공 여부와 관계없이 홈화면으로 이동
                                print("🚀 API 결과와 관계없이 홈화면으로 이동")
                                goToBodyRecord = true
                            }
                        }
                    }) {
                        Text("시작하기")
                            .font(.PretendardSemiBold18)
                            .foregroundStyle(Color.grey00)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.orange05)
                            .cornerRadius(30)
                            .padding(.horizontal)
                    }
                    .disabled(isStarting)
                    .padding(.bottom, 20)
                    .alert("추천 생성 실패", isPresented: $showError) {
                        Button("확인", role: .cancel) {}
                    } message: {
                        Text("네트워크 상태를 확인하고 다시 시도해 주세요.")
                    }
                    .navigationDestination(isPresented: $goToBodyRecord) {
                        OnboardingBodyRecordView(viewModel: OnboardingViewModel())
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - MetricRow
struct MetricRow: View {
    let title: String
    let change: MetricChange

    var body: some View {
        let valueColor: Color = title == "몸무게" ? .orange05 : .grey05

        HStack {
            Text(title)
                .font(.PretendardMedium16)
                .foregroundColor(.grey05)
            Spacer()
            HStack(spacing: 6) {
                if !change.after.isEmpty {
                    Text("\(change.before) → \(change.after)")
                        .font(.PretendardMedium16)
                        .foregroundColor(valueColor)
                } else {
                    Text(change.before)
                        .font(.PretendardMedium16)
                        .foregroundColor(valueColor)
                }

                if let diff = change.diff {
                    Text(diff)
                        .font(.PretendardMedium12)
                        .foregroundColor(.orange05)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.orange01)
                        .cornerRadius(30)
                }
            }
        }
    }
}
 
// MARK: - Preview

#Preview {
    OnboradingDiagnosisView(
        nickname: "서연",
        diagnosis: DiagnosisInputModel(
            weightChange: MetricChange(before: "70kg", after: "67kg", diff: "-3kg"),
            bmiChange: MetricChange(before: "24.5", after: "22.1", diff: "-2.4"),
            bodyFatChange: MetricChange(before: "30%", after: "25%", diff: "-5%"),
            muscleMassChange: MetricChange(before: "28kg", after: "29kg", diff: "+1kg"),
            comment: "체지방이 높은 편입니다. 유산소 운동을 늘려보세요!",
            exerciseGoals: [
                ExerciseGoal(type: "유산소", mainInfo: "주 3회 30분", detail: "빠르게 걷기나 자전거 타기 추천"),
                ExerciseGoal(type: "근력", mainInfo: "주 2회 40분", detail: "하체 위주 루틴 구성")
            ],
            dietGoals: [
                DietGoal(key: "권장 섭취 열량", value: "1800 kcal"),
                DietGoal(key: "탄수화물", value: "200g"),
                DietGoal(key: "단백질", value: "100g")
            ]
        )
    )
}
