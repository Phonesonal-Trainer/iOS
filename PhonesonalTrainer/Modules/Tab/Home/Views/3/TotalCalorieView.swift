//
//  TotalCalorieView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/29/25.
//
import SwiftUI

struct TotalCalorieView: View {
    let todayCalories: Int      // 현재 칼로리
    let targetCalories: Int       // 목표 칼로리

    var body: some View {
       // let diff = todayCalories - targetCalories // 목표 - 현재
       // let diffText = String(format: "%+d kcal", diff)

        VStack(alignment: .leading, spacing: 0) {
                    // 상단 텍스트 라인
                    HStack {
                        Text("총 칼로리")
                            .font(.system(size: 14))
                            .foregroundColor(.grey04)

                      //  Spacer() .frame(width: 5)

                       // Text(diffText)
                            //.font(.system(size: 12))
                           // .foregroundColor(.orange05)
                    }
            
                    Spacer().frame(height: 15)

            // 중간 현재/목표 칼로리
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(todayCalories)")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.grey05)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .layoutPriority(1)

                            Text("/ \(targetCalories)")
                                .font(.system(size: 18))
                                .foregroundColor(.grey02)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .layoutPriority(1)
                        }

            // 단위
            Text("kcal")
                .font(.system(size: 16))
                .foregroundColor(.grey02)

            Spacer()
        }
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0)) // ✅ 왼쪽만 패딩
               .frame(width: 160, height: 125, alignment: .leading)
        .background(Color.grey00)
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}
#Preview {
    TotalCalorieView(todayCalories: 1234, targetCalories: 2345)
        .previewLayout(.sizeThatFits)
}

