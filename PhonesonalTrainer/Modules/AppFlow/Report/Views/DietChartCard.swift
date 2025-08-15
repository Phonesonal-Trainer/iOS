import SwiftUI

struct DietChartCard: View {
    let totalKcal: Int
    let totalGoalKcal: Int
    let avgKcal: Int
    let dailyKcals: [DayOfWeek: Double?]
    @State private var selected: DayOfWeek? = nil

    var body: some View {
        CardContainer(background: .grey00) {
            VStack(alignment: .leading, spacing: 16) {
                Text("식단 그래프")
                    .font(.PretendardSemiBold18)

                HStack(alignment: .top, spacing: 28) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Text("\(totalKcal)kcal").font(.PretendardSemiBold16).foregroundColor(.orange05)
                            Text("/ \(totalGoalKcal)kcal").font(.PretendardMedium12).foregroundColor(.grey03)
                        }
                        Text("이번주 총 섭취 칼로리").font(.PretendardRegular12).foregroundColor(.grey03)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(avgKcal)kcal")
                            .font(.PretendardSemiBold16)
                            .foregroundColor(.grey05)
                        Text("일일 평균 섭취 칼로리")
                            .font(.PretendardRegular12)
                            .foregroundColor(.grey03)
                    }
                }

                DietBarChart(data: dailyKcals, selected: $selected)
                    .padding(.top, 40)
                    .frame(height: 200)
            }
        }
    }
}

struct DietChartCard_Previews: PreviewProvider {
    static var previews: some View {
        DietChartCard(
            totalKcal: 1234,
            totalGoalKcal: 2345,
            avgKcal: 123,
            dailyKcals: [
                .monday: 1800,
                .tuesday: 1400,
                .wednesday: 2200,
                .thursday: 1600,
                .friday: 2000,
                .saturday: 1700,
                .sunday: 1500
            ]
        )
        .padding()
        .background(Color.grey00)
    }
}


