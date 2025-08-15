import SwiftUI

struct WeightBarChart: View {
    let data: [DayOfWeek: Double?]
    @Binding var selected: DayOfWeek?

    private let chartHeight: CGFloat = 140

    private var validValues: [Double] {
        data.compactMap { $0.value ?? nil }
    }

    private var minValue: Double { (validValues.min() ?? 0) - 1 }
    private var maxValue: Double { (validValues.max() ?? 0) + 1 }

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // Y axis labels
            VStack(alignment: .trailing) {
                Text("65").font(.PretendardSemiBold12).foregroundColor(.grey05)
                Spacer()
                Text("50").font(.PretendardSemiBold12).foregroundColor(.grey05)
                Spacer()
                Text("35").font(.PretendardSemiBold12).foregroundColor(.grey05)
            }
            .frame(height: chartHeight)
            .padding(.bottom, 20)

            // Bars
            HStack(alignment: .bottom, spacing: 16) {
                ForEach(DayOfWeek.ordered, id: \.self) { day in
                let value = data[day] ?? nil
                VStack {
                    ZStack(alignment: .bottom) {
                        Capsule()
                            .fill(Color.grey01)
                            .frame(width: 26, height: chartHeight)

                        if let value = value {
                            let height = barHeight(for: value)
                            Capsule()
                                .fill(Color.orange02)
                                .frame(width: 26, height: height)
                                .overlay(alignment: .top) { EmptyView() }
                        }
                    }
                    .overlay(alignment: .top) {
                        if selected == day, let v = value {
                            VStack(spacing: 2) {
                                Text("\(String(format: "%.0f", v))kg")
                                    .font(.PretendardRegular12)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.black.opacity(0.85))
                                    .cornerRadius(6)
                                TrianglePointer()
                                    .fill(Color.black.opacity(0.85))
                                    .frame(width: 10, height: 6)
                            }
                            // Place bubble on top of the grey background bar (not dependent on fill height)
                            .offset(y: -36)
                            .allowsHitTesting(false)
                        }
                    }
                    Text(day.displayShortKorean)
                        .font(.PretendardRegular14)
                        .foregroundColor(.grey03)
                }
                .onTapGesture { selected = selected == day ? nil : day }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
    }

    private func barHeight(for value: Double) -> CGFloat {
        guard maxValue > minValue else { return 0 }
        let ratio = (value - minValue) / (maxValue - minValue)
        return CGFloat(20 + ratio * 100) // min 20, max 120
    }
}

private struct TrianglePointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct WeightBarChart_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(Optional<DayOfWeek>.none) { selection in
            WeightBarChart(
                data: ReportPreviewData.mockSomeMissing.weekly.dailyWeights,
                selected: selection
            )
            .padding()
            .background(Color.reportBackground)
        }
    }
}


