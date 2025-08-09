//
//  my.GoalView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/10/25.
//

import SwiftUI

// 값만 바뀌는 구조 (각 항목의 현재값/목표값)
struct GoalNumbers {
    let current: Double
    let goal: Double
}

// 한 번에 넘길 데이터 모델
struct GoalStatsData {
    let weight: GoalNumbers      // kg
    let bodyFat: GoalNumbers     // %
    let muscle: GoalNumbers      // kg
    let bmi: GoalNumbers         // (단위 없음)
}

// 공통 스타일 (폰트/컬러 프로젝트 스타일 사용) — 네가 바꾼 값 그대로
struct GoalMetricStyle {
    var titleFont: Font = .PretendardMedium14
    var valueFont: Font = .PretendardSemiBold22
    var unitFont:  Font = .PretendardMedium16
    var diffFont:  Font = .PretendardRegular12

    var titleColor: Color = .grey03
    var valueColor: Color = .grey05
    var unitColor:  Color = .grey02
    var diffColor:  Color = .orange05

    var cardCorner: CGFloat = 5
    var cardPadding: CGFloat = 20
    var cardShadowOpacity: Double = 0.1
}

// 고정 항목 정의 (타이틀/단위 고정)
enum GoalMetricType: CaseIterable {
    case weight, bodyFat, muscle, bmi

    var title: String {
        switch self {
        case .weight:  return "몸무게"
        case .bodyFat: return "체지방률"
        case .muscle:  return "골격근량"
        case .bmi:     return "BMI"
        }
    }
    var unit: String? {
        switch self {
        case .weight, .muscle: return "kg"
        case .bodyFat:         return "%"
        case .bmi:             return nil
        }
    }
    // 값 포맷 소수 자릿수
    var valueDigits: Int {
        switch self {
        case .bodyFat: return 0
        default:       return 1
        }
    }
}


struct MyGoalView: View {
    let data: GoalStatsData
    var style = GoalMetricStyle()
    var onSeeAll: () -> Void

    private let order: [GoalMetricType] = [.weight, .bodyFat, .muscle, .bmi]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // 상단: 제목 + 자세히보기 (네가 지정한 폰트/색)
            HStack {
                Text("목표 수치")
                    .font(.PretendardMedium20)
                    .foregroundStyle(.grey05)

                Spacer()

                Button(action: onSeeAll) {
                    Text("자세히 보기")
                        .font(.PretendardRegular14)
                        .foregroundStyle(.grey03)
                }
            }

            // 2열(고정폭 160), 열 간격 20, 행 간격 20
            LazyVGrid(
                columns: [
                    GridItem(.fixed(160), spacing: 20),
                    GridItem(.fixed(160), spacing: 20)
                ],
                spacing: 20
            ) {
                ForEach(order, id: \.self) { type in
                    GoalBox(
                        type: type,
                        numbers: numbers(for: type),
                        style: style
                    )
                    // 카드 자체 고정 사이즈 160x115
                    .frame(width: 160, height: 115, alignment: .topLeading)
                }
            }
        }
       
        .frame(width: 340, alignment: .leading)
    
    }

    //  반드시 MyGoalView 내부에 있어야 data를 볼 수 있음
    private func numbers(for type: GoalMetricType) -> GoalNumbers {
        switch type {
        case .weight:  return data.weight
        case .bodyFat: return data.bodyFat
        case .muscle:  return data.muscle
        case .bmi:     return data.bmi
        }
    }
}

// 카드 1개 (재사용) — 타이틀/단위 고정, 값만 주입
struct GoalBox: View {
    let type: GoalMetricType
    let numbers: GoalNumbers
    var style: GoalMetricStyle

    private var valueText: String {
        String(format: "%.\(type.valueDigits)f", numbers.current)
    }
    private var diffText: String {
        let diff = numbers.goal - numbers.current
        let sign = diff >= 0 ? "-" : "+"
        let absVal = abs(diff)
        let formatted = String(format: "%.\(type.valueDigits)f", absVal)
        if let unit = type.unit, !unit.isEmpty {
            return "목표까지 \(sign)\(formatted)\(unit)"
        } else {
            return "목표까지 \(sign)\(formatted)"
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.grey00)
                .shadow(color: .black.opacity(style.cardShadowOpacity), radius: 2)

            VStack(alignment: .leading, spacing: 0) {
                       // title
                       Text(type.title)
                           .font(style.titleFont)
                           .foregroundStyle(style.titleColor)
                           .padding(.bottom, 10) // ⬅️ title ↔ HStack = 10

                       // value + unit
                       HStack(alignment: .lastTextBaseline, spacing: 4) {
                           Text(valueText)
                               .font(style.valueFont)
                               .foregroundStyle(style.valueColor)
                           if let unit = type.unit {
                               Text(unit)
                                   .font(style.unitFont)
                                   .foregroundStyle(style.unitColor)
                           }
                       }
                       .padding(.bottom, 5) // ⬅️ HStack ↔ diff = 5

                       // diff
                       Text(diffText)
                           .font(style.diffFont)
                           .foregroundStyle(style.diffColor)
                   
            }
            .padding(style.cardPadding) // 고정 높이(115) 안에서 여백 적용
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    MyGoalView(
        data: .init(
            weight:  .init(current: 52.5, goal: 55.0),
            bodyFat: .init(current: 22,   goal: 17),
            muscle:  .init(current: 27.3, goal: 29.0),
            bmi:     .init(current: 19.1, goal: 18.0)
        ),
        onSeeAll: { }
    )
}
