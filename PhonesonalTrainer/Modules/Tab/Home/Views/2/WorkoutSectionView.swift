//
//  WorkoutSectionView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//

import SwiftUI

struct WorkoutSectionView: View {
    @StateObject var workoutViewModel = CalorieProgressWorkoutViewModel(kcal: 1234, goal: 2456)

    var body: some View {
        VStack(spacing: 20) {
            CalorieProgressWorkoutView(viewModel: workoutViewModel)
            WorkoutInfoView()
        }
        .padding(20)
        .frame(width: 340, height: 244)
        .background(Color.grey00)
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
#Preview {
    WorkoutSectionView()
}
