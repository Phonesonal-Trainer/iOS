//
//  WorkoutInfoView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//

import SwiftUI

struct WorkoutInfoView: View {
    var focus: String = "상체"//더미
        var anaerobic: Int = 40 //더미
        var aerobic: Int = 15//더미
    
   // var focus: String     // 상체, 하체 등 // 얘가 찐
  //  var anaerobic: Int    // 무산소 분 // 얘가 찐
   // var aerobic: Int      // 유산소 분  // 얘가 찐 

    var body: some View {
        HStack(spacing: 0) {
            workoutColumn(title: "집중부위", value: focus, isTime: false)

            Spacer().frame(width: 25)
            dividerLine()
            Spacer().frame(width: 25)

            workoutColumn(title: "무산소", value: "\(anaerobic)분", isTime: true)

            Spacer().frame(width: 25)
            dividerLine()
            Spacer().frame(width: 25)

            workoutColumn(title: "유산소", value: "\(aerobic)분", isTime: true)
        }
        .frame(width: 256, height: 44)
    }

    private func workoutColumn(title: String, value: String, isTime: Bool) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 14)) // 네가 바꿔
                .foregroundColor(.grey03)
            Text(value)
                .font(.system(size: 18, weight: .semibold)) // 네가 바꿔
                .foregroundColor(.grey05)
        }
        .frame(width: 52)
    }

    private func dividerLine() -> some View {
        Rectangle()
            .fill(Color.grey01)
            .frame(width: 1, height: 30)
    }
}

#Preview {
    WorkoutInfoView(focus: "상체", anaerobic: 20, aerobic: 30)
        .padding()
}
