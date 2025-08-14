//
//  WorkoutListCard.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/5/25.
//

import SwiftUI

struct WorkoutListCard: View {
    // MARK: - Property
    let workout: WorkoutModel
    var onInfoTap: () -> Void
    
    
    // MARK: - 상수 정의
    fileprivate enum WorkoutListCardConstants {
        static let baseWidth: CGFloat = 340
        static let baseHeight: CGFloat = 109
        static let basePadding: CGFloat = 20
        static let VSpacing: CGFloat = 10
        static let textIconSpacing: CGFloat = 4
        static let searchIconSize: CGFloat = 22
        static let statusIconSize: CGFloat = 32
        static let recordedHPadding: CGFloat = 12
        static let recordedVPadding: CGFloat = 10
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: WorkoutListCardConstants.VSpacing) {
            HStack {
                HStack(spacing: WorkoutListCardConstants.textIconSpacing) {
                    /// 운동 이름
                    Text(workout.name)
                        .font(.PretendardSemiBold20)
                        .foregroundStyle(Color.grey05)
                    
                    /// 운동 상세보기로 이동
                    Image("searchIcon")
                        .resizable()
                        .frame(width: WorkoutListCardConstants.searchIconSize, height: WorkoutListCardConstants.searchIconSize)
                        .onTapGesture {
                            onInfoTap()
                        }
                }
                
                Spacer()
                
                statusIcon
            }
            /// 가로선
            Rectangle()
                .fill(Color.line)
                .frame(height: 1)
            
            subText
        }
        .padding(.horizontal, WorkoutListCardConstants.basePadding)
        .frame(height: WorkoutListCardConstants.baseHeight)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.grey00)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
        )
    }
    
    // MARK: - 운동 상태에 따라 다르게 나타나는 버튼
    private var statusIcon: some View {
        VStack(spacing: 0) {
            if workout.status == .inProgress {
                Button(action: {
                    // 운동 타이머 화면으로 이동
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .foregroundStyle(Color.grey05)
                        .frame(width: WorkoutListCardConstants.statusIconSize, height: WorkoutListCardConstants.statusIconSize)
                }
            } else if workout.status == .done {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.orange05)
                    .frame(width: WorkoutListCardConstants.statusIconSize, height: WorkoutListCardConstants.statusIconSize)
            } else {
                Text("기록된 운동")
                    .font(.PretendardRegular12)
                    .foregroundStyle(Color.grey04)
                    .padding(.horizontal, WorkoutListCardConstants.recordedHPadding)
                    .padding(.vertical, WorkoutListCardConstants.recordedVPadding)
                    .background(Color.grey01)
                    .cornerRadius(5)
            }
        }
        
    }
    
    // MARK: - n세트 nkg / 소모된 칼로리
    private var subText: some View {
        HStack {
            if workout.status == .recorded {
                Text("\(formatKcal(workout.kcalBurned ?? 0)) kcal 소모")
                    .font(.PretendardRegular14)
                    .foregroundStyle(Color.grey04)
            } else {
                // 세트 번호 + 무게 나열
                let setTexts = workout.exerciseSets.map { "\($0.setNumber)세트 \($0.weight)kg" }
                Text(setTexts.joined(separator: ", "))
                    .font(.PretendardRegular14)
                    .foregroundStyle(Color.grey04)
            }
            Spacer()
        }
    }
}
