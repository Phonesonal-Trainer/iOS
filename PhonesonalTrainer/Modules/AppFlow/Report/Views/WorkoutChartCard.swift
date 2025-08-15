import SwiftUI

struct WorkoutChartCard: View {
    let totalKcal: Int
    let totalGoalKcal: Int
    let avgKcal: Int
    let dailyKcals: [DayOfWeek: Double?]
    @State private var selected: DayOfWeek? = nil

    var body: some View {
        CardContainer(background: .grey00) {
            VStack(alignment: .leading, spacing: 16) {
                Text("운동 그래프")
                    .font(.PretendardSemiBold18)

                HStack(alignment: .top, spacing: 28) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Text("\(totalKcal)kcal")
                                .font(.PretendardSemiBold16)
                                .foregroundColor(.orange05)
                            Text("/ \(totalGoalKcal)kcal")
                                .font(.PretendardMedium12)
                                .foregroundColor(.grey03)
                        }
                        Text("이번주 총 소모 칼로리").font(.PretendardRegular12).foregroundColor(.grey03)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(avgKcal)kcal")
                            .font(.PretendardSemiBold16)
                            .foregroundColor(.grey05)
                        Text("일일 평균 소모 칼로리")
                            .font(.PretendardRegular12)
                            .foregroundColor(.grey03)
                    }
                }

                WorkoutBarChart(data: dailyKcals, selected: $selected)
                    .padding(.top, 40)
                    .frame(height: 200)
            }
        }
    }
}

struct WorkoutChartCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutChartCard(
            totalKcal: 1234,
            totalGoalKcal: 2345,
            avgKcal: 123,
            dailyKcals: [
                .monday: 1200,
                .tuesday: 800,
                .wednesday: 1500,
                .thursday: 1100,
                .friday: 900,
                .saturday: 700,
                .sunday: 600
            ]
        )
        .padding()
        .background(Color.reportBackground)
    }
}


