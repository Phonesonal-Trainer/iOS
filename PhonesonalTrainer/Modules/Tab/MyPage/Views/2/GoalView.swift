//
//  GoalView.swift
//  PhonesonalTrainer
//

import SwiftUI

struct GoalView: View {
    @Environment(\.dismiss) private var dismiss

    let recommend: RecommendedGoalsUIModel
    let workout: WorkoutGoalsUIModel
    let meal: MealGoalsUIModel

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                Spacer().frame(height: 25) // ✅ 상단바 아래 25 확실히 띄우기

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) { // ✅ 카드 사이 25
                        RecommendGoalView(model: recommend)
                        WorkoutGoalView(model: workout)
                        MealGoalView(model: meal)
                    }
                    .padding(.horizontal, 25) // ✅ 좌우 25
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var topBar: some View {
        ZStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.grey05)
                }
                Spacer()
            }
            Text("목표 수치")
                .font(.PretendardMedium22)
                .foregroundStyle(.grey06)
        }
        .padding(.horizontal, 25)
        .frame(height: 56)
        .background(Color.grey00)
    }
}
#Preview {
    NavigationStack {
        GoalView(
            recommend: .init(
                weightFrom: "55 kg", weightTo: "49 kg", weightDiff: "-6kg",
                bmiFrom: "21.5", bmiTo: "19.1", bmiDiff: "-2.4",
                fatFrom: "30%", fatTo: "22%", fatDiff: "-8%p",
                skeletalTag: "유지 또는 소폭 증가"
            ),
            workout: .init(
                routine: "주 3회 / 1시간",
                anaerobic: "주 3회 / 40분",
                aerobic: "주 2회 / 20분"
            ),
            meal: .init(
                nutrient: "고단백/저지방",
                amount: "1300 ~ 1400 kcal"
            )
        )
    }
}
