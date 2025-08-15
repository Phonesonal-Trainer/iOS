//
//  TimerHeader.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import SwiftUI

struct TimerHeader: View {
    enum Mode { case preparation, rest, active }
    
    let mode: Mode
    let type: WorkoutType
    let title: String                       // 준비 시간/휴식 시간/운동명
    let workoutIndex: Int                   // 2
    let totalWorkouts: Int                  // 7
    let totalSets: Int                      // 3
    @Binding var soundOn: Bool
    
    fileprivate enum TimerHeaderConstants {
        static let height: CGFloat = 68
        static let hSpacing: CGFloat = 15
        static let hPadding: CGFloat = 75
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 60)
                .fill(Color.grey05)
            
            HStack(spacing:0) {
                Text(title)
                    .font(.PretendardMedium20)
                    .foregroundStyle(Color.grey00)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: TimerHeaderConstants.hSpacing) {
                    // 가운데(운동 중일 때만)
                    if mode == .active {
                        if type == .anaerobic {
                            // 무산소
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(workoutIndex)/\(totalWorkouts)")
                                    .font(.PretendardMedium16)
                                    .foregroundStyle(Color.grey01)
                                
                                Text("\(totalSets)세트")
                                    .font(.PretendardMedium14)
                                    .foregroundStyle(Color.grey02)
                            }
                        } else {
                            Text("\(workoutIndex)/\(totalWorkouts)")
                                .font(.PretendardMedium16)
                                .foregroundStyle(Color.grey01)
                        }
                    }
                    
                    if type == .anaerobic {
                        // 오른쪽: 소리버튼
                        SoundToggleButton(isOn: $soundOn)
                    }
                }
                .frame(height: TimerHeaderConstants.height)
                .padding(.horizontal, TimerHeaderConstants.hPadding)
            }
        }
    }
}

struct SoundToggleButton: View {
    @Binding var isOn: Bool
    
    fileprivate enum C {
        static let size: CGFloat = 34
    }
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.12)) { isOn.toggle() }
        } label: {
            Image(isOn ? "unmuteIcon" : "muteIcon")
                .resizable()
                .frame(width: C.size, height: C.size)
        }
        .buttonStyle(.plain)
    }
}

