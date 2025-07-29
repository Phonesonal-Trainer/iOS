//
//  HomeHeaderView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//

import SwiftUI

struct HomeHeaderView: View {
    var startDate: Date
    var currentDate: Date

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(currentWeek)주차")
                    .font(.custom("Pretendard-SemiBold", size: 24))
                    .foregroundStyle(.orange05)

                Text(formattedDate(currentDate))
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

    var currentWeek: Int {
        weeksBetween(startDate: startDate, endDate: currentDate)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    func weeksBetween(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfStartDate = calendar.startOfDay(for: startDate)
        let startOfEndDate = calendar.startOfDay(for: endDate)

        let components = calendar.dateComponents([.weekOfYear], from: startOfStartDate, to: startOfEndDate)
        return max(0, components.weekOfYear ?? 0)
    }
}

#Preview {
    HomeHeaderView(
        startDate: Calendar.current.date(byAdding: .day, value: -21, to: Date())!, // 3주 전
        currentDate: Date()
    )
}
