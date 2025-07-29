//
//  MealPlanSectionView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//
 
import SwiftUI

struct MealPlanSectionView: View {
    let carbs: Int
    let protein: Int
    let fat: Int

    var body: some View {
        VStack(spacing: 20) {
            CalorieProgressMealView(viewModel: CalorieProgressMealViewModel(kcal: 800, goal: 1000))

            NutrientView(carbs: carbs, protein: protein, fat: fat)
    
                    }
        .padding(20)
        .frame(width: 340, height: 244)
        .background(Color.grey00)
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
#Preview {
    let dummy = NutrientInfoModel(mealType: "아침", kcal: 1234, carb: 180, protein: 70, fat: 30)
    return MealPlanSectionView(
        carbs: dummy.carb,
        protein: dummy.protein,
        fat: dummy.fat
    )
}
