//
//  WorkoutDetailSheetView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/6/25.
//

import SwiftUI

struct WorkoutDetailSheetView: View {
    // MARK: - Property
    let workout: WorkoutModel
    @State private var isExpanded = false
    @Environment(\.dismiss) private var dismiss  // ← 시트 닫기용
    
    // MARK: - Constants
    fileprivate enum SheetConstants {
        static let baseWidth: CGFloat = 340
        static let xButtonSize: CGFloat = 20
        static let alertIconSize: CGFloat = 18  // 유의사항 아이콘
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                /// 상단
                VStack(alignment: .leading) {
                    /// 운동 이름  + 'x'
                    HStack {
                        Text(workout.name)
                            .font(.PretendardSemiBold22)
                            .foregroundStyle(Color.grey06)
                        
                        Spacer()
                        
                        // X 닫기 버튼
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.grey06)
                                .frame(width: SheetConstants.xButtonSize, height: SheetConstants.xButtonSize)
                        }
                    }
                    /// 부위 + 사용 근육들
                    Text("\(workout.bodyPart) (\(workout.muscleGroups.joined(separator: ", ")))")
                        .font(.PretendardMedium16)
                        .foregroundStyle(Color.grey03)
                }
                /// 운동 이미지
                workoutImage
                /// 운동 방법 코글
            //    workoutInstruction
                /// 운동 유의사항
                workoutCaution
                
                /// 유튜브 썸네일 (링크 연결 가능)
                //if let youtubeURL = workout.youtubeURL {
                //    Link(destination: youtubeURL) {
                //        ZStack {
                //            Rectangle()
                 //               .fill(Color.gray.opacity(0.2))
                //                .frame(height: 180)
                //                .overlay(
               //                     Image(systemName: "play.circle.fill")
                //                        .resizable()
               //                         .scaledToFit()
                //                        .frame(width: 50)
               //                         .foregroundStyle(.red)
               //                 )
                //        }
               //     }
               // }
            }
        }
    }
    
    // MARK: - 운동 이미지
    private var workoutImage: some View {
        // 운동 이미지
        // 나중에 imageURL 로 수정
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 180)
            .overlay(Text("운동 이미지 들어갈 자리"))
    }
    
    // MARK: - 운동 방법
  //  private var workoutInstruction: some View {
        // 운동 방법 토글
        // json 받아오면 InstructionStep Model도 불러와서 다시 코드 짜기..
      //  DisclosureGroup("운동 방법", isExpanded: $isExpanded) {
      //      Text(workout.instructions ?? "운동 방법 설명이 없습니다.")
       //         .font(.body)
       //         .padding(.top, 8)
       //     }
      //      .font(.headline)
       //     .padding()
       //     .background(Color.gray.opacity(0.1))
       //     .cornerRadius(8)
  //  }
    
    // MARK: - 운동 유의사항
    private var workoutCaution: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image("AlertIcon2")
                    .resizable()
                    .frame(width: SheetConstants.alertIconSize, height: SheetConstants.alertIconSize)
                    .padding(.trailing, 5)
                
                Text("유의사항")
                    .font(.PretendardSemiBold18)
                    .foregroundStyle(Color.grey05)
            }
            
            // json 받아오면 InstructionStep Model도 불러와서 다시 코드 짜기..
     //       ForEach(workout.cautions ?? [], id: \.self) { caution in
     //           Text("• \(caution)")
     //               .font(.PretendardMedium12)
     //               .foregroundStyle(Color.grey03)
     //       }
        }
        .padding()
        .background(Color.orange01)
        .cornerRadius(5)
    }
}

// #Preview {
//     WorkoutDetailSheetView()
// }
