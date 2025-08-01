//
//  WeightInfoView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/29/25.
//

import SwiftUI

struct WeightInfoView: View {
    let currentWeight: Double   // 오늘 몸무게
    let goalWeight: Double      // 목표 몸무게
    let onTap: () -> Void       // 버튼 탭 시 액션 (팝업 띄우기)

    var body: some View {
        let diff = currentWeight - goalWeight
        let diffText = String(format: "%+.1f kg", diff)

        Button(action: {
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // 상단 텍스트 라인
                HStack {
                    Text("오늘 몸무게")
                        .font(.system(size: 14))
                        .foregroundColor(.grey04)

                    Spacer().frame(width: 5)

                    Text(diffText)
                        .font(.system(size: 12))
                        .foregroundColor(.orange05)
                }

                Spacer().frame(height: 15)

                // 중간 현재/목표 몸무게
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", currentWeight))
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.grey05)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .layoutPriority(1)

                    Text("/ \(String(format: "%.1f", goalWeight))")
                        .font(.system(size: 18))
                        .foregroundColor(.grey02)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .layoutPriority(1)
                }

                // 단위
                Text("kg")
                    .font(.system(size: 16))
                    .foregroundColor(.grey02)

                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0))
            .frame(width: 160, height: 125, alignment: .leading)
            .background(Color.grey00)
            .cornerRadius(5)
            .shadow(color: .black.opacity(0.1), radius: 2)
        }
        .buttonStyle(PlainButtonStyle()) // 버튼 스타일 안 보이게!
    }
}
#Preview {
    WeightInfoView(
        currentWeight: 64.3,
        goalWeight: 60.0,
        onTap: {
            print("몸무게 입력 팝업 열기!") // 👉 프리뷰에서 팝업은 못 띄우니까 콘솔로 확인
        }
    )
    .previewLayout(.sizeThatFits)
    .padding()
}
