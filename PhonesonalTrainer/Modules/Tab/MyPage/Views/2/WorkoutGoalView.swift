//
//  WorkoutGoalView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/10/25.
//

import SwiftUI

// API → View용 모델 (표시는 이미 포맷된 문자열로)
struct WorkoutGoalsUIModel {
    let routine: String    // 예: "주 3회 / 1시간"
    let anaerobic: String  // 예: "주 3회 / 40분"
    let aerobic: String    // 예: "주 2회 / 20분"
}

struct WorkoutGoalView: View {
    let model: WorkoutGoalsUIModel

    // MARK: - 상수 (RecommendGoalView와 동일)
    private enum C {
        static let titleToCardSpacing: CGFloat = 20
        static let cardHPad: CGFloat = 20
        static let cardVPad: CGFloat = 20
        static let rowToLineSpacing: CGFloat = 15
        static let lineWidth: CGFloat = 300 // 340 - (좌우 패딩 20*2)
    }

    // 무산소 고정 서브텍스트
    private let anaerobicNote = "상체/하체/전신 하루씩"

    var body: some View {
        VStack(alignment: .leading, spacing: C.titleToCardSpacing) {
            Text("운동 목표")
                .font(.PretendardMedium20)
                .foregroundStyle(.grey05)

            VStack(spacing: 0) {
                // 주기
                row("주기", model.routine)
                line.padding(.vertical, C.rowToLineSpacing)

                // 무산소 (서브텍스트 포함)
                row("무산소", model.anaerobic, subtitle: anaerobicNote)
                line.padding(.vertical, C.rowToLineSpacing)

                // 유산소
                row("유산소", model.aerobic)
            }
            .padding(.vertical, C.cardVPad)
            .padding(.horizontal, C.cardHPad)
            .background(Color.grey00)
            .cornerRadius(5)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Row (오른쪽 정렬, 단일 텍스트)
    private func row(_ title: String, _ value: String, subtitle: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(title)
                    .font(.PretendardMedium16)
                    .foregroundStyle(.grey05)
                    .lineLimit(1)
                    .layoutPriority(2)

                Spacer(minLength: 8)

                Text(value)
                    .font(.PretendardMedium16)
                    .foregroundStyle(.grey05)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .allowsTightening(true)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
            }

            if let subtitle {
                HStack {
                    Spacer()
                    Text(subtitle)
                        .font(.PretendardRegular14)
                        .foregroundStyle(.grey03)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    private var line: some View {
        Rectangle()
            .fill(Color.line)
            .frame(width: C.lineWidth, height: 1, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WorkoutGoalView(
        model: .init(
            routine: "주 3회 / 1시간",
            anaerobic: "주 3회 / 40분",
            aerobic: "주 2회 / 20분"
        )
    )
}
