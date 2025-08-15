import SwiftUI

struct WeightChartCard: View {
    let changeFromTarget: Double?
    let changeFromInitial: Double?
    let dailyWeights: [DayOfWeek: Double?]
    @State private var selected: DayOfWeek? = nil

    var body: some View {
        CardContainer(background: .grey00) {
            VStack(alignment: .leading, spacing: 16) {
                Text("체중 그래프")
                    .font(.PretendardSemiBold18)
                
                HStack(alignment: .top, spacing: 28) {
                    VStack(alignment: .leading, spacing: 6) {
                        MetricBadge(value: changeFromTarget, color: .clear, textColor: .orange05, font: .PretendardSemiBold16)
                        Text("목표 대비")
                            .font(.PretendardRegular12)
                            .foregroundColor(.grey03)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        MetricBadge(value: changeFromInitial, color: .clear, textColor: .grey05, font: .PretendardSemiBold16)
                        Text("0주차 대비")
                            .font(.PretendardRegular12)
                            .foregroundColor(.grey03)
                    }
                }
            }
            WeightBarChart(data: dailyWeights, selected: $selected)
                .padding(.top, 40)
                .frame(height: 200)
        }
    }
}

struct WeightChartCard_Previews: PreviewProvider {
    static var previews: some View {
        WeightChartCard(
            changeFromTarget: ReportPreviewData.mockAllFilled.weekly.changeFromTarget,
            changeFromInitial: ReportPreviewData.mockAllFilled.weekly.changeFromInitial,
            dailyWeights: ReportPreviewData.mockAllFilled.weekly.dailyWeights
        )
        .padding()
        .background(Color.grey00)
    }
}


