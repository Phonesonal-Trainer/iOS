import SwiftUI

struct DietBarChart: View {
    let data: [DayOfWeek: Double?]
    @Binding var selected: DayOfWeek?

    private let chartHeight: CGFloat = 140

    private var validValues: [Double] { data.compactMap { $0.value ?? nil } }
    private var minValue: Double { min(validValues.min() ?? 0, 0) }
    private var maxValue: Double { max(validValues.max() ?? 0, 3500) }

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            // Y axis labels (3500/1750/0)
            VStack(alignment: .trailing) {
                Text("3500").font(.PretendardSemiBold12).foregroundColor(.grey05)
                Spacer()
                Text("1750").font(.PretendardSemiBold12).foregroundColor(.grey05)
                Spacer()
                Text("0").font(.PretendardSemiBold12).foregroundColor(.grey05)
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
                            }
                        }
                        .overlay(alignment: .top) {
                            if selected == day, let v = value {
                                VStack(spacing: 2) {
                                    Text("\(Int(v))kcal")
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

struct DietBarChart_Previews: PreviewProvider {
    static var previews: some View {
        let sample: [DayOfWeek: Double?] = [
            .monday: 1800,
            .tuesday: 1400,
            .wednesday: 2200,
            .thursday: 1600,
            .friday: 2000,
            .saturday: 1700,
            .sunday: 1500
        ]
        return StatefulPreviewWrapper(Optional<DayOfWeek>.none) { selection in
            DietBarChart(data: sample, selected: selection)
                .padding()
                .background(Color.reportBackground)
        }
    }
}


