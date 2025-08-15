//
//  WorkoutTimerView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import SwiftUI

struct WorkoutTimerView: View {
    // MARK: - Property
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: WorkoutTimerViewModel
    @Binding var path: [WorkoutRoutineRoute]
    @State private var showStopPopup = false
    
    init(viewModel: WorkoutTimerViewModel, path: Binding<[WorkoutRoutineRoute]>) {
        _viewModel = StateObject(wrappedValue: viewModel) // ✅ 주입
        _path = path
    }
    
    fileprivate enum C {
        static let timerSize: CGFloat = 240
        static let middleVSpacing: CGFloat = 20
        static let buttonHSpacing: CGFloat = 20
        static let buttonWidth: CGFloat = 260
        static let nextIconSize: CGFloat = 24
    }
    
    var pausedButtonColor: Color {
        viewModel.isPaused ? .orange05 : .grey05
    }
    var pausedButtonText: String {
        viewModel.isPaused ? "이어서" : "일시 정지"
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                /// 상단 뒤로가기 버튼
                HStack {
                    Button {
                        viewModel.stopTapped()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.grey05)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .padding(.bottom, 10)
                .background(Color.grey00)
                .zIndex(1)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        // 운동 이름 + 소리
                        TimerHeader(
                            mode: headerMode,
                            type: viewModel.type == .anaerobic ? .anaerobic : .aerobic,
                            title: {
                                switch viewModel.phase {
                                case .preparation: return "준비 시간"
                                case .rest:        return "휴식 시간"
                                default:           return viewModel.workoutName
                                }
                            }(),
                            workoutIndex: viewModel.workoutIndex,
                            totalWorkouts: viewModel.totalWorkoutsToday,
                            totalSets: viewModel.totalSets,
                            soundOn: $viewModel.soundOn
                        )
                        
                        VStack(spacing: C.middleVSpacing) {
                            // 원형 타이머
                            CircularTimer(progress: viewModel.progress, isPaused: viewModel.isPaused)
                                .frame(height: C.timerSize)
                                .overlay(
                                    VStack(spacing: 5) {
                                        Text(timeString(viewModel.secondsElapsed))
                                            .font(.system(size: 28, weight: .semibold))
                                            .foregroundStyle(Color.grey06)
                                        
                                        if viewModel.type == .anaerobic {
                                            if viewModel.phase == .preparation {
                                                Text("준비 시간")
                                                    .font(.PretendardMedium18)
                                                    .foregroundStyle(Color.orange05)
                                            } else if viewModel.phase == .rest {
                                                Text("휴식 시간")
                                                    .font(.PretendardMedium18)
                                                    .foregroundStyle(Color.orange05)
                                            } else {
                                                HStack(spacing: 0) {
                                                    Text("\(viewModel.currentSetIndex)")
                                                        .foregroundStyle(Color.orange05)
                                                    Text("/\(viewModel.totalSets) 세트")
                                                        .foregroundStyle(Color.grey03)
                                                    Text(" | \(viewModel.weight)kg")
                                                        .foregroundStyle(Color.orange05)
                                                }
                                                .font(.PretendardMedium18)
                                            }
                                        }
                                    }
                                )
                            
                            // 하단: 카운트
                            HStack(alignment: .bottom) {
                                Text("\(min(viewModel.currentReps, viewModel.targetReps))")
                                    .font(.PretendardSemiBold22)
                                    .foregroundStyle(Color.orange05)
                                Text(" / \(viewModel.targetReps)")
                                    .font(.PretendardRegular20)
                                    .foregroundStyle(Color.grey03)
                            }
                            
                            // 버튼
                            buttons
                        }
                        
                    }
                }
            }
            if showStopPopup {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                StopWorkoutPopup(
                    isPresented: $showStopPopup,
                    onConfirm: {
                        // 1) 진행상황 저장(inProgress로 유지/완료 세트까지만)
                        viewModel.confirmStop()
                        
                        // 2) 팝업 닫고 네비게이션 루트로
                        showStopPopup = false
                        path.removeAll()   // NavigationStack 루트(WorkoutRoutineView)로 이동
                    }
                )
                .transition(.scale)
                .zIndex(2)
            }
        }
        .onChange(of: showStopPopup) { _, newValue in
            if !newValue, viewModel.isPaused {
                viewModel.togglePause()  // 팝업 닫히면 타이머 재개
            }
        }
    }
    
    // MARK: - 캡슐에 적힌 운동 상태
    private var headerMode: TimerHeader.Mode {
        switch viewModel.phase {
        case .preparation: return .preparation
        case .rest:        return .rest
        case .setActive:   return .active
        case .finished:    return .active
        }
    }
    
    // MARK: - 타이머 시간
    private func timeString(_ s: Int) -> String {
        String(format: "%02d:%02d", s/60, s%60)
    }
    
    // MARK: - 버튼들
    private var buttons: some View {
        VStack {
            if viewModel.phase == .preparation || viewModel.phase == .rest {
                HStack {
                    VStack(spacing: 5) {
                        Text("다음 운동")
                            .font(.PretendardMedium14)
                            .foregroundStyle(Color.grey03)
                        // 다음 운동명
                        Text(viewModel.nextWorkoutName)
                            .font(.PretendardSemiBold20)
                            .foregroundStyle(Color.grey05)
                    }
                    Spacer()
                    
                    Button{
                        viewModel.goToNextExercise()
                    } label: {
                        Image("nextIcon")
                            .resizable()
                            .frame(width: C.nextIconSize, height: C.nextIconSize)
                    }
                }
                .padding(.all, C.buttonHSpacing)
                .background(.grey00)
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.1), radius: 2)
                .padding(.top, 60)
            } else if viewModel.phase == .finished {
                SubButton(color: .orange05, text: "운동 완료", textColor: .grey00
                ) {
                    dismiss() // 완료 후 리스트로 복귀
                }
                .frame(width: C.buttonWidth)
            } else {
                HStack(spacing: C.buttonHSpacing) {
                    // 그만하기 버튼
                    SubButton(color: .grey01, text: "그만하기", textColor: .grey04){
                        viewModel.stopTapped()
                    }
                    // '일시정지' or '이어서'
                    
                    SubButton(color: pausedButtonColor, text: pausedButtonText, textColor: .grey00) {
                        viewModel.togglePause()
                    }
                }
                .frame(width: C.buttonWidth)
            }
        }
    }
}

// #Preview {
//     WorkoutTimerView()
// }
