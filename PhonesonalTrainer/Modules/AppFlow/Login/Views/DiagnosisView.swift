//
//  DiagnosisView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

struct DiagnosisView: View {
    let nickname: String
    let diagnosis: DiagnosisModel   // 모델 데이터 주입

    // 추천 목표 수치를 배열로 구성
    private var metrics: [(String, MetricChange)] {
        [
            ("몸무게", diagnosis.weightChange),
            ("BMI", diagnosis.bmiChange),
            ("체지방률", diagnosis.bodyFatChange ?? MetricChange(before: "-", after: "", diff: nil)),
            ("골격근량", diagnosis.muscleMassChange ?? MetricChange(before: "-", after: "", diff: nil))
        ]
    }

    var body: some View {
        ZStack {
            Color.grey00.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // 헤더
                    BackHeader {
                        // 뒤로가기 로직
                    }

                    // 페이지 인디케이터
                    PageIndicator(
                        totalPages: 4,
                        currentPage: 3,
                        activeColor: .orange05,
                        inactiveColor: .grey01
                    )

                    // 타이틀
                    VStack(alignment: .leading, spacing: 6) {
                        Text("폰스널 트레이너의 진단")
                            .font(.PretendardSemiBold24)
                            .foregroundColor(.grey06)
                        Text("\(nickname)님 맞춤형 진단이에요.")
                            .font(.PretendardRegular20)
                            .foregroundColor(.grey03)
                    }
                    .padding(.horizontal)

                    // 진단 코멘트
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .center, spacing: 6) {
                            Image("코멘트아이콘")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("폰스널 트레이너의 진단")
                                .font(.PretendardMedium14)
                                .foregroundColor(.orange05)
                        }
                        Text(diagnosis.comment)
                            .font(.PretendardMedium12)
                            .foregroundColor(.grey05)
                            .padding(.top, 2)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange01)
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                    // 추천 목표 수치
                    VStack(alignment: .leading, spacing: 16) {
                        Text("추천 목표 수치")
                            .font(.PretendardMedium18)
                            .foregroundColor(.grey06)
                            .padding(.bottom, 12)

                        VStack(spacing: 16) {
                            ForEach(Array(metrics.enumerated()), id: \.offset) { index, metric in
                                MetricRow(title: metric.0, change: metric.1)
                                if index < metrics.count - 1 { Divider() } // 마지막 항목에는 Divider 없음
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
                            .foregroundColor(.grey06)
                            .padding(.bottom, 12)

                        ForEach(Array(diagnosis.exerciseGoals.enumerated()), id: \.element.id) { index, goal in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(goal.type)
                                        .font(.PretendardMedium16)
                                        .foregroundColor(.grey05)
                                    Spacer()
                                    Text(goal.mainInfo)
                                        .font(.PretendardMedium16)
                                        .foregroundColor(.grey05)
                                }
                                if let detail = goal.detail {
                                    Text(detail)
                                        .font(.PretendardRegular14)
                                        .foregroundColor(.grey03)
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
                            .foregroundColor(.grey06)
                            .padding(.bottom, 12)

                        ForEach(Array(diagnosis.dietGoals.enumerated()), id: \.element.id) { index, goal in
                            HStack {
                                Text(goal.key)
                                    .font(.PretendardMedium16)
                                    .foregroundColor(.grey05)
                                Spacer()
                                Text(goal.value)
                                    .font(.PretendardMedium16)
                                    .foregroundColor(.grey05)
                            }
                            if index < diagnosis.dietGoals.count - 1 { Divider() }
                        }
                        .padding(.horizontal, 28)
                    }
                    .padding(.horizontal, 20)

                    // 시작하기 버튼
                    Button(action: {
                        print("시작하기 버튼 클릭")
                    }) {
                        Text("시작하기")
                            .font(.PretendardSemiBold18)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.orange05)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

#Preview {
    DiagnosisView(nickname: "서연", diagnosis: .dummy)
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
