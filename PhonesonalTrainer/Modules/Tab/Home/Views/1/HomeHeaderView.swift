//
//  HomeHeaderView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//

import SwiftUI

struct HomeHeaderView: View {
    private enum Mode {
        case computed(startDate: Date, currentDate: Date) // 기존 방식
        case direct(week: Int, dateText: String)          // 서버 텍스트 직주입
    }
    private let mode: Mode

    // 기존 초기화(프리뷰/과거 코드 호환)
    init(startDate: Date, currentDate: Date) {
        self.mode = .computed(startDate: startDate, currentDate: currentDate)
    }
    // 신규: 서버 값으로 바로 주입
    init(week: Int, dateText: String) {
        self.mode = .direct(week: week, dateText: dateText)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(displayWeek)주차")
                    .font(.custom("Pretendard-SemiBold", size: 24))
                    .foregroundStyle(.orange05)
                Text(displayDateText)
                    .font(.custom("Pretendard-Regular", size: 18))
                    .foregroundStyle(.grey05)
            }
            Spacer()
            Image("logo")
                .resizable()
                .frame(width: 56, height: 56)
        }
        .frame(width: 340, height: 56)
        .padding(.horizontal, 25)
    }

    private var displayWeek: Int {
        switch mode {
        case let .computed(start, current):
            return weeksBetween(startDate: start, endDate: current)
        case let .direct(week, _):
            return max(0, week)
        }
    }
    private var displayDateText: String {
        switch mode {
        case let .computed(_, current):
            return formattedDate(current)
        case let .direct(_, dateText):
            return dateText
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy년 MM월 dd일 (E)"
        f.locale = Locale(identifier: "ko_KR")
        return f.string(from: date)
    }
    private func weeksBetween(startDate: Date, endDate: Date) -> Int {
        let cal = Calendar.current
        let s = cal.startOfDay(for: startDate)
        let e = cal.startOfDay(for: endDate)
        let comp = cal.dateComponents([.weekOfYear], from: s, to: e)
        return max(0, comp.weekOfYear ?? 0)
    }
}

#Preview {
    HomeHeaderView(
        startDate: Calendar.current.date(byAdding: .day, value: -21, to: Date())!, // 3주 전
        currentDate: Date()
    )
}
