//
//  WorkoutListView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/4/25.
//

import SwiftUI

// iOS 16/17 모두 지원하는 onChange 래퍼
private struct OnChangeModifier: ViewModifier {
    var selectedDate: Date
    var action: (Date) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content.onChange(of: selectedDate, initial: true) { _, newValue in
                action(newValue)
            }
        } else {
            content.onChange(of: selectedDate) { newValue in
                action(newValue)
            }
        }
    }
}

struct WorkoutListView: View {
    // 부모에서 주입
    @ObservedObject var viewModel: WorkoutListViewModel
    let selectedDate: Date

    fileprivate enum WorkoutListConstants {
        static let baseWidth: CGFloat = 340
        static let VSpacing: CGFloat = 15
        static let cardListVSpacing: CGFloat = 10
    }

    var body: some View {
        VStack {
            // 세그먼트
            WorkoutListSegmentView(selectedTab: $viewModel.selectedTab)
                .padding(.bottom, WorkoutListConstants.VSpacing)

            // 타입 섹션별 리스트
            LazyVStack(spacing: WorkoutListConstants.VSpacing) {
                ForEach(WorkoutType.allCases, id: \.self) { type in
                    if let workouts = viewModel.filteredWorkouts[type], !workouts.isEmpty {
                        Section(header: sectionHeader(for: type)) {
                            VStack(spacing: WorkoutListConstants.cardListVSpacing) {
                                ForEach(workouts) { workout in
                                    WorkoutListCard(workout: workout, onInfoTap: { viewModel.showDetail(for: workout) })
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: WorkoutListConstants.baseWidth)
        }
        // iOS 16 이하: 초기 로드만 onAppear에서
        .onAppear {
            if #unavailable(iOS 17) { viewModel.loadWorkouts(for: selectedDate) }
        }
        // iOS 17 이상: initial=true 로 최초 1회 + 변경 시 호출 / iOS 16 이하: 변경 시 호출
        .modifier(OnChangeModifier(selectedDate: selectedDate) { newDate in
            viewModel.loadWorkouts(for: newDate)
        })
        // sheet: activeDetail이 세팅되면 열림
        .sheet(item: $viewModel.activeDetail) { detail in
            WorkoutDetailSheetView(detail: detail)
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


