import SwiftUI

struct WeekNavigatorView: View {
    let weekTitle: String // 예: "3주차"
    let periodText: String // 예: "2025.07.28 – 2025.08.03"
    let onPrev: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack(spacing: 24) {
            Button(action: onPrev) { Image(systemName: "chevron.left").font(.PretendardMedium18) }
                .foregroundStyle(Color.grey02)
            VStack(spacing: 6) {
                Text(weekTitle)
                    .font(.PretendardMedium18)
                    .foregroundStyle(Color.grey05)
                Text(periodText)
                    .font(.PretendardMedium12)
                    .foregroundStyle(Color.grey03)
            }
            Button(action: onNext) { Image(systemName: "chevron.right").font(.PretendardMedium18) }
                .foregroundStyle(Color.grey02)
        }
        .padding(.vertical, 8)
    }
}

struct WeekNavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        WeekNavigatorView(weekTitle: "3주차", periodText: "2025.07.28 – 2025.08.03", onPrev: {}, onNext: {})
            .padding()
            .background(Color.reportBackground)
    }
}


