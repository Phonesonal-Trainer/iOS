//
//  CalorieGuageMeal.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/28/25.
//

import SwiftUI

struct CalorieGaugeMealView: View {
    var percentage: Double // 0.0 ~ 2.0 이상 가능

    // 표시용 퍼센트 텍스트
    private var displayPercentText: String {
        "\(Int(percentage * 100))%"
    }

    // 상태 텍스트
    private var statusText: String {
        switch percentage {
        case 0:
            return "시작 전"
        case 0..<0.61:
            return "부족"
        case 0.61..<1.10:
            return "적정"
        default:
            return "초과"
        }
    }

    // 상태 텍스트 색상
    private var statusTextColor: Color {
        switch percentage {
        case 0:
            return .grey04
        case 0..<0.26:
            return .red00
        case 0.26..<0.61:
            return .grey06
        case 0.61..<1.10:
            return .green00
        case 1.10..<1.40:
            return .grey06
        default:
            return .red00
        }
    }

    // 원호 색상 (nil이면 아예 표시 X)
    private var arcColor: Color? {
        switch percentage {
        case 0:
            return nil
        case 0..<0.26, 1.40...:
            return .red00
        case 0.26..<0.61, 1.10..<1.40:
            return .yellow00
        case 0.61..<1.10:
            return .green00
        default:
            return nil
        }
    }

    // 원호 그릴 퍼센트 (최대 100%)
    private var arcProgress: Double {
        percentage == 0 ? 0.0 : min(percentage, 1.0)
    }

    var body: some View {
        ZStack {
            // 회색 배경 원
            Circle()
                .stroke(.grey01, lineWidth: 6)
                .frame(width: 125, height: 125)

            // 텍스트
            VStack(spacing: 4) {
                Text(displayPercentText)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.grey06)

                Text(statusText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(statusTextColor)
            }

            // 바깥 원호 (조건부로 나타남)
            if let color = arcColor {
                Circle()
                    .trim(from: 0.0, to: arcProgress)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 145, height: 145)
                    .rotationEffect(.degrees(-90))
            }
        }
    }
}
#Preview {
    // 연동된 값: 2150 / 2000 = 107.5%
    CalorieGaugeMealView(percentage: 1.075)
}
