//
//  WeekProgressView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/10/25.
//

import SwiftUI

struct WeeksProgressView: View {
    // API에서 내려줄 값
    let signUpDate: Date          // 회원가입 시점
    let targetWeeks: Int          // 목표 기간(주차) e.g. 4, 12, 24
    var now: Date = Date()        // 테스트/프리뷰용 현재시각 주입 가능

    // 계산 값
    private var togetherWeeks: Int {
        max(0, min(weeksBetween(signUpDate, now), targetWeeks))
    }
    private var progress: CGFloat {
        guard targetWeeks > 0 else { return 0 }
        return CGFloat(togetherWeeks) / CGFloat(targetWeeks)
    }

    var body: some View {
        VStack(spacing: 5) {
            // 상단 라벨
            Text("폰스널트레이너와 함께한지")
                .font(.PretendardMedium16)
                .foregroundStyle(.grey05)

            // 4주차 / 15주차
            HStack(spacing: 5) {
                Text("\(togetherWeeks)주차")
                    .font(.PretendardSemiBold20)
                    .foregroundStyle(.orange05)

                Text("/")
                    .font(.PretendardRegular16)
                    .foregroundStyle(.grey03)

                Text("\(targetWeeks)주차")
                    .font(.PretendardRegular16)
                    .foregroundStyle(.grey03)
            }

            Spacer().frame(height: 15)
            
            // 진행 바
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.orange02))
                        .frame(width: 340, height: 10)

                    // 진한색 (끝 둥글게)
                    Capsule()
                        .fill(Color(.orange05))
                        .frame(width: geo.size.width * progress, height: 10)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 10)

            // 하단 0주차 / 목표주차
            HStack {
                Text("0주차")
                    .font(.PretendardMedium14)
                    .foregroundStyle(.grey03)
                Spacer()
                Text("\(targetWeeks)주차")
                    .font(.PretendardMedium14)
                    .foregroundStyle(.grey03)
            }
        }
        .padding(.horizontal, 16)
    }

    // 주차 계산(일수/7, 내림)
    private func weeksBetween(_ start: Date, _ end: Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return max(0, days / 7)
    }
}

// MARK: - 월→주 변환 헬퍼 (온보딩 선택값용)
enum GoalMonths: Int {
    case one = 1, three = 3, six = 6
    var weeks: Int {
        switch self {
        case .one:  return 4
        case .three:return 12
        case .six:  return 24
        }
    }
}

// MARK: - Preview (더미)
#Preview {
    WeeksProgressView(
        signUpDate: Calendar.current.date(byAdding: .weekOfYear, value: -4, to: Date())!,
        targetWeeks: 15
    )
    .padding()
    .background(Color(.systemBackground))
}
