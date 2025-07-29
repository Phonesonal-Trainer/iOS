//
//  WorkoutRoutineView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/30/25.
//

import SwiftUI

struct WorkoutRoutineView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    Text("운동 루틴")
                        .font(.PretendardMedium22)
                        .foregroundStyle(.grey05)
                        .padding(.bottom, 20)
                    
                    WeeklyCalendarView()
                    
                    /// 일단 divider 로 구현해둠
                    Divider()
                }
                .background(Color.grey00)
                .zIndex(1)
                
                ScrollView {
                    
                }
            }
        }
    }
}

#Preview {
    WorkoutRoutineView()
}
