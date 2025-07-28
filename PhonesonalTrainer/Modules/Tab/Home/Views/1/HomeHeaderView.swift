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
        VStack(alignment: .leading, spacing: 4) {
            Text("\(currentWeek)주차")
                .font(.system(size: 24))
                .bold()
                .foregroundStyle(.orange05)
            
            Text(formattedDate(currentDate))
                .font(.system(size: 18))
                .foregroundStyle(.grey05)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding( .horizontal)
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
        let components = calendar.dateComponents([.weekOfYear], from: startDate, to: endDate)
        return (components.weekOfYear ?? 0) + 1
    }
}

#Preview {
    HomeHeaderView(
        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 23))!,
        currentDate: Date()
    )
}
