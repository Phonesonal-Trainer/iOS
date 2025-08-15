import SwiftUI

struct MetricBadge: View {
    let value: Double?
    let color: Color
    let textColor: Color
    let font: Font

    init(value: Double?, color: Color = .clear, textColor: Color = .grey06, font: Font = .PretendardSemiBold20) {
        self.value = value
        self.color = color
        self.textColor = textColor
        self.font = font
    }

    private var text: String { NumberParsing.formatSignedKg(value) }

    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(textColor)
            .accessibilityLabel("변화량 \(text)")
    }
}


