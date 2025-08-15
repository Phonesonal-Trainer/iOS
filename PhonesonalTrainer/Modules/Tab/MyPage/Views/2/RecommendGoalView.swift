//
//  RecommendGoalView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/10/25.
//

import SwiftUI

// API → View용 모델
struct RecommendedGoalsUIModel {
    let weightFrom: String
    let weightTo: String
    let weightDiff: String

    let bmiFrom: String
    let bmiTo: String
    let bmiDiff: String

    let fatFrom: String
    let fatTo: String
    let fatDiff: String

    let skeletalTag: String // 예: "<유지 또는 소폭 증가>"
}

struct RecommendGoalView: View {
    let model: RecommendedGoalsUIModel

    // MARK: - 상수
    private enum C {
        static let titleToCardSpacing: CGFloat = 20
        static let cardHPad: CGFloat = 20
        static let cardVPad: CGFloat = 20
        static let rowToLineSpacing: CGFloat = 15
        static let lineWidth: CGFloat = 300 // 340 - (좌우 패딩 20*2)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: C.titleToCardSpacing) {
            Text("추천 목표 수치")
                .font(.PretendardMedium20)
                .foregroundStyle(.grey05)

            VStack(spacing: 0) {
                row("몸무게", model.weightFrom, model.weightTo, model.weightDiff, highlight: true)  // from→to 주황
                line.padding(.vertical, C.rowToLineSpacing)

                row("BMI", model.bmiFrom, model.bmiTo, model.bmiDiff, highlight: false)              // from→to 회색
                line.padding(.vertical, C.rowToLineSpacing)

                row("체지방률", model.fatFrom, model.fatTo, model.fatDiff, highlight: false)          // from→to 회색
                line.padding(.vertical, C.rowToLineSpacing)

                rowSingle("골격근량", model.skeletalTag) // 화살표/배지 없음, 단일 텍스트
            }
            .padding(.vertical, C.cardVPad)
            .padding(.horizontal, C.cardHPad)
            .background(Color.grey00)
            .cornerRadius(5)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Row (화살표 + 배지: 배지는 전부 주황)
    private func row(_ title: String,
                     _ from: String,
                     _ to: String,
                     _ badge: String,
                     highlight: Bool) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(title)
                .font(.PretendardMedium16)
                .foregroundStyle(.grey05)
                .lineLimit(1)
                .layoutPriority(2) // 왼쪽 라벨 보호

            Spacer(minLength: 8)

            HStack(spacing: 8) {
                Text("\(from) → \(to)")
                    .font(.PretendardMedium16)
                    .foregroundStyle(highlight ? .orange05 : .grey05) // 몸무게만 주황
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .allowsTightening(true)

                Text(badge) // 배지는 전부 주황
                    .font(.PretendardMedium12)
                    .foregroundStyle(.orange05)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange01)
                    .cornerRadius(30)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            .frame(maxWidth: .infinity, alignment: .trailing) // 오른쪽 정렬
            .multilineTextAlignment(.trailing)
        }
    }

    // MARK: - Row (단일 텍스트)
    private func rowSingle(_ title: String, _ tag: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(title)
                .font(.PretendardMedium16)
                .foregroundStyle(.grey05)
                .lineLimit(1)
                .layoutPriority(2)

            Spacer(minLength: 8)

            Text(tag)
                .font(.PretendardMedium16)
                .foregroundStyle(.grey05)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .allowsTightening(true)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
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
    RecommendGoalView(
        model: .init(
            weightFrom: "55 kg", weightTo: "49 kg", weightDiff: "-6kg",
            bmiFrom: "21.5", bmiTo: "19.1", bmiDiff: "-2.4",
            fatFrom: "30%", fatTo: "22%", fatDiff: "-8%p",
            skeletalTag: "<유지 또는 소폭 증가>"
        )
    )
}
