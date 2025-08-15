import SwiftUI

struct CardContainer<Content: View>: View {
    let background: Color
    let content: () -> Content

    init(background: Color = .grey00, @ViewBuilder content: @escaping () -> Content) {
        self.background = background
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        .frame(maxWidth: .infinity) // ✅ 이것만 추가하면 해결됩니다!
        .background(background)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
    }
}

extension Notification.Name {
    static let reportFeedbackSubmitted = Notification.Name("reportFeedbackSubmitted")
}
