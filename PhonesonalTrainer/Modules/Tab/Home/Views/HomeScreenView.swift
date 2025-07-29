//
//  HomeView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//
import SwiftUI

struct HomeScreenView: View {
    @State private var showWeightPopup = false
    @State private var weightText = ""

    @State private var currentWeight: Double = 66.6 // 팝업에서 변경될 몸무게 상태

    // 예시 날짜
    let startDate = Date().addingTimeInterval(-60*60*24*30)
    let currentDate = Date()

    var body: some View {
        ZStack {
            // 회색 배경
            Color(.grey01)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 25) {
                        HomeHeaderView(startDate: startDate, currentDate: currentDate)

                        TrainerCommentView()

                        HomeTabView()

                        DailyStatusView(
                            currentWeight: currentWeight,
                            goalWeight: 60.0,
                            totalCalorie: 1300,
                            calorieGoal: 2000,
                            onWeightTap: {
                                showWeightPopup = true
                            }
                        )

                        BodyPicView()

                        Spacer(minLength: 80)
                    }
                    .frame(width: 340)
                    .padding(.vertical, 20)
                }

               
            }

            // 팝업
            if showWeightPopup {
                Color("black00")
                    .opacity(0.5)
                    .ignoresSafeArea()

                WeightPopupView(
                    weightText: $weightText,
                    onCancel: {
                        showWeightPopup = false
                    },
                    onSave: { newWeight in
                        currentWeight = newWeight //여기서 갱신됨
                        weightText = ""
                        showWeightPopup = false
                    }
                )
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
