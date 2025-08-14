//
//  WorkoutRoutineView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/30/25.
//

import SwiftUI

struct WorkoutRoutineView: View {
    // MARK: - Property
    @Binding var path: [WorkoutRoutineRoute]
    
    @State private var selectedDate: Date = Date()                  //  상위로 올린 날짜 상태
    @StateObject private var listVM = WorkoutListViewModel()
    
    // MARK: - 상수 정의
    fileprivate enum WorkoutRoutineConstants {
        static let baseWidth: CGFloat = 340
        static let VSpacing: CGFloat = 25
        static let addWorkoutButtonWidth: CGFloat = 94
        static let addWorkoutButtonHeight: CGFloat = 41
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("운동 루틴")
                    .font(.PretendardMedium22)
                    .foregroundStyle(.grey05)
                    .padding(.bottom, 20)
                
                WeeklyCalendarView(selectedDate: $selectedDate)
                
                /// 일단 divider 로 구현해둠
                Divider()
            }
            .background(Color.grey00)
            .zIndex(1)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: WorkoutRoutineConstants.VSpacing) {
                    topContent
                    
                    WorkoutListView(viewModel: listVM, selectedDate: selectedDate)
                }
            }
        }
        .background(Color.background)
        .navigationDestination(for: WorkoutRoutineRoute.self) { route in
            switch route {
            case .workoutSearch:
                WorkoutSearchView(path: $path)
            case .manualAdd:
                ManualAddWorkoutView()
            }
        }
    }
    
    // MARK: - '총 소모 칼로리' + '운동추가' 버튼
    private var topContent: some View {
        HStack {
            KcalBurnedView()
            
            Spacer()
            
            Button(action: {
                path.append(.workoutSearch)
            }) {
                Text("+ 운동 추가")
                    .font(.PretendardMedium14)
                    .foregroundStyle(Color.orange05)
                    .frame(width: WorkoutRoutineConstants.addWorkoutButtonWidth, height: WorkoutRoutineConstants.addWorkoutButtonHeight)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.orange01)
                    )
            }
        }
        .padding(.top, WorkoutRoutineConstants.VSpacing)
        .frame(width: WorkoutRoutineConstants.baseWidth)
    }
}

#Preview {
    StatefulPreviewWrapper([WorkoutRoutineRoute]()) { path in
        WorkoutRoutineView(path: path)
    }
}
