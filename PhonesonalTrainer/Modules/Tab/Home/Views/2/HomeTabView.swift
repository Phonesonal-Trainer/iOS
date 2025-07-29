//
//  HomeTabView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//

import SwiftUI

enum HomeTabType: String, CaseIterable {
    case workout = "운동 루틴"
    case meal = "식단 플랜"
}

struct HomeTabView: View {
    @State private var selectedTab: HomeTabType = .workout
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(HomeTabType.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    Text(tab.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedTab == tab ? .grey00 : .orange05)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == tab ? Color.orange05 : Color.orange01)
                }
            }
        }
        .cornerRadius(8)
        .frame(width: 340)
        
        if selectedTab == .workout {
            WorkoutSectionView()
        } else {
            MealPlanSectionView(
                carbs: 111,
                protein: 111,
                fat: 111
            )
        }
        
    }
}
#Preview {
    HomeTabView()
}
