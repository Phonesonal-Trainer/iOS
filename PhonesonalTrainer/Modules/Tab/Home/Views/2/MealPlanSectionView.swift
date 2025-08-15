import SwiftUI

struct MealPlanSectionView: View {
    @EnvironmentObject var home: HomeViewModel
    @StateObject private var mealVM = CalorieProgressMealViewModel(kcal: 0, goal: 0)

    var body: some View {
        VStack(spacing: 20) {
            CalorieProgressMealView(viewModel: mealVM)
            NutrientView(
                carbs: Double(home.carb),
                protein: Double(home.protein),
                fat: Double(home.fat)
            )
        }
        .padding(20)
        .frame(width: 340, height: 244)
        .background(Color.grey00)
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.1), radius: 2)
        .onAppear {
            mealVM.apply(
                kcal: home.todayConsumedCalorie,
                goal: home.todayRecommendedCalories
            )
        }
        .onChange(of: home.todayConsumedCalorie) { newVal in
            mealVM.apply(kcal: newVal, goal: home.todayRecommendedCalories)
        }
        .onChange(of: home.todayRecommendedCalories) { newVal in
            mealVM.apply(kcal: home.todayConsumedCalorie, goal: newVal)
        }
    }
}

#Preview {
    let dummy = HomeViewModel()
    dummy.todayConsumedCalorie = 800
    dummy.todayRecommendedCalories = 1000
    dummy.carb = 180
    dummy.protein = 70
    dummy.fat = 30
    return MealPlanSectionView().environmentObject(dummy)
}
