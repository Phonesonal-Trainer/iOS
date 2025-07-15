//
//  WeekCalendarView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/16/25.
//
// 고쳐야 할 것...!
// 1. startDate -> 그냥 무작정 0주차부터 보여주는거... => 현재 날짜에 해당하는 주차부터 보여주는 걸로 바꿔
// 2. 날짜 선택했을 때 옆에것들이 자꾸 밀리는거.. -> RoundedRectangle 때문인 것 같은데..

import SwiftUI

struct WeeklyCalendarView: View {
    @State private var currentWeekOffset: Int = 0
    @State private var selectedDate: Date = Date()
    
    private let calendar = Calendar.current
    
    // 기준 주의 시작일 (앱 시작 시 기준)
    // 현재 임의로 날짜 넣음. 나중에 백엔드와 연결.
    private let startDate: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 10))!
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            weekHeader
            
            weekDaysView
        }
    }
    
    // Mark: - 주차 헤더
    
    private var weekHeader : some View {
        HStack(spacing : 30) {
            Button(action : {
                if currentWeekOffset > 0 {
                    currentWeekOffset -= 1
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(canGoToPreviousWeek ? .grey05 : .grey02)
                    .padding()
            }
            .disabled(!canGoToPreviousWeek)
            
            Text("\(currentWeekOffset)주차")
                .font(.PretendardMedium18)
            
            Button(action: {
                if currentWeekOffset < maxWeekOffset {
                    currentWeekOffset += 1
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(canGoToNextWeek ? .grey05 : .grey02)
                    .padding()
            }
            .disabled(!canGoToNextWeek)
        }
    }
    
    // Mark: - 일주일 날짜 뷰
    private var weekDaysView : some View {
        let weekDates = generateDatesForWeek(offset: currentWeekOffset)
        
        return HStack(spacing : 26.5){
            ForEach(weekDates, id: \.self) { date in
                VStack(spacing: 8){
                    ZStack{
                        if calendar.isDate(selectedDate, inSameDayAs: date) {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.grey05)
                                .frame(width: 43, height: 69)
                        }
                        VStack(spacing: 10) {
                            Text(dayName(from: date))
                                .font(.PretendardMedium12)
                                .frame(width: 23)
                                .foregroundColor(
                                    calendar.isDate(selectedDate, inSameDayAs: date) ? .grey01 : .grey02
                                )
                            
                            Text("\(calendar.component(.day, from: date))")
                                .frame(width: 23)
                                .foregroundColor(
                                    calendar.isDate(selectedDate, inSameDayAs: date) ? .grey01 : .grey05
                                )
                        }
                        
                    }
                    
                    if calendar.isDateInToday(date) {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 8, height: 8)
                    } else {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 8, height: 8)
                    }
                }
                .onTapGesture{
                    selectedDate = date
                }
            }
        }
    }
    
    // Mark : -Helper
    private var maxWeekOffset: Int {
        let weeks = calendar.dateComponents([.weekOfYear], from: startDate, to: Date()).weekOfYear ?? 0
        return max(0, weeks)
    }
        
    private var canGoToPreviousWeek: Bool {
        currentWeekOffset > 0
    }
        
    private var canGoToNextWeek: Bool {
        currentWeekOffset < maxWeekOffset
    }
    
    private func generateDatesForWeek(offset: Int) -> [Date] {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: startDate)!.start
        guard let weekStartDate = calendar.date(byAdding: .weekOfYear, value: offset, to: startOfWeek) else {
            return []
        }
        
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: weekStartDate)
        }
    }
    
    private func dayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

#Preview {
    WeeklyCalendarView()
}
