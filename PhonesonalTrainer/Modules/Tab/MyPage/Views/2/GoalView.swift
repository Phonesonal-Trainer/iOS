import SwiftUI

struct GoalView: View {
    let recommend: RecommendedGoalsUIModel
    let workout: WorkoutGoalsUIModel
    let meal: MealGoalsUIModel

    var body: some View {
        // TODO: 실제 UI로 교체
        VStack(spacing: 16) {
            Text("GoalView")
                .font(.system(size: 20, weight: .semibold))
            VStack(alignment: .leading, spacing: 8) {
                Text("추천 목표: \(recommend.weightFrom) → \(recommend.weightTo) / BMI \(recommend.bmiFrom) → \(recommend.bmiTo)")
                Text("체지방: \(recommend.fatFrom) → \(recommend.fatTo) (\(recommend.fatDiff))")
                Text("골격근: \(recommend.skeletalTag)")
                Text("운동 루틴: \(workout.routine)")
                Text("무산소: \(workout.anaerobic)")
                Text("유산소: \(workout.aerobic)")
                Text("식단: \(meal.nutrient) / \(meal.amount)")
            }
            .font(.system(size: 14))
        }
        .padding()
        .navigationTitle("목표 자세히")
    }
}
