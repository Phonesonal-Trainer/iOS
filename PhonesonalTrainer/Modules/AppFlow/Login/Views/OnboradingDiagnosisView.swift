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

    @State private var goToBodyRecord = false
    @Environment(\.dismiss) private var dismiss

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
                                    Image("코멘트아이콘")
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
                        goToBodyRecord = true
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
                    .padding(.bottom, 20)
                }

                .navigationDestination(isPresented: $goToBodyRecord) {
                    OnboardingBodyRecordView(viewModel: OnboardingViewModel())
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
