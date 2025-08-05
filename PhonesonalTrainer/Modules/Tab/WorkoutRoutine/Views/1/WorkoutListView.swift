//
//  WorkoutListView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/4/25.
//

import SwiftUI

struct WorkoutListView: View {
    // MARK: - Property
    @StateObject private var viewModel = WorkoutListViewModel()
    
    // MARK: - 상수 정의
    fileprivate enum WorkoutListConstants {
        static let baseWidth: CGFloat = 340
        static let VSpacing: CGFloat = 15
        static let cardListVSpacing: CGFloat = 10
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            /// 운동 상태 선택 세그먼트
            WorkoutListSegmentView(selectedTab: $viewModel.selectedTab)
                .padding(.bottom, WorkoutListConstants.VSpacing)
            
            LazyVStack(spacing: WorkoutListConstants.VSpacing) {
                ForEach(WorkoutType.allCases, id: \.self) { type in
                    if let workouts = viewModel.filteredWorkouts[type], !workouts.isEmpty {
                        Section(header: sectionHeader(for: type)) {
                            VStack(spacing: WorkoutListConstants.cardListVSpacing) {
                                ForEach(workouts) { workout in
                                    WorkoutListCard(workout: workout)
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: WorkoutListConstants.baseWidth)
        }
    }
    
    @ViewBuilder
    private func sectionHeader(for type: WorkoutType) -> some View {
        HStack {
            Text(type.rawValue)
                .font(.PretendardMedium16)
                .foregroundStyle(Color.orange05)
            
            Spacer()
        }
    }
}

#Preview {
    WorkoutListView()
}
