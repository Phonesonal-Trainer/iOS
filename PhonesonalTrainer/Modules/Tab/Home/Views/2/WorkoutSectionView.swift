import SwiftUI

struct WorkoutSectionView: View {
    @EnvironmentObject var home: HomeViewModel
    @StateObject var workoutViewModel = CalorieProgressWorkoutViewModel(kcal: 0, goal: 0)

    var body: some View {
        VStack(spacing: 20) {
            CalorieProgressWorkoutView(viewModel: workoutViewModel)

            WorkoutInfoView(
                focusedBodyPart: home.focusPart,
                anaerobicExerciseTime: home.anaerobicMin,
                aerobicExerciseTime: home.aerobicMin
            )
        }
        .padding(20)
        .frame(width: 340, height: 244)
        .background(Color.grey00)
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.1), radius: 2)
        .onAppear {
            workoutViewModel.apply(
                kcal: home.todayBurnedCalories,
                goal: home.todayRecommendBurnedCalories
            )
        }
        .onChange(of: home.todayBurnedCalories) { _, newVal in
            workoutViewModel.apply(kcal: newVal, goal: home.todayRecommendBurnedCalories)
        }
        .onChange(of: home.todayRecommendBurnedCalories) { _, newVal in
            workoutViewModel.apply(kcal: home.todayBurnedCalories, goal: newVal)
        }
    }
}

#Preview {
    let dummy = HomeViewModel()
    dummy.todayBurnedCalories = 1100
    dummy.todayRecommendBurnedCalories = 1000
    dummy.focusedBodyPart = "상체"
    dummy.anaerobicExerciseTime = 40
    dummy.aerobicExerciseTime = 20

    return WorkoutSectionView()
        .environmentObject(dummy)
}
