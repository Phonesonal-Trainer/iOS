import SwiftUI

enum ReportTopTab: String, CaseIterable { case all = "전체", workout = "운동", diet = "식단" }

private struct TabWidthKey: PreferenceKey {
    static var defaultValue: [ReportTopTab: CGFloat] = [:]
    static func reduce(value: inout [ReportTopTab: CGFloat], nextValue: () -> [ReportTopTab: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct ReportTopTabView: View {
    @Binding var selected: ReportTopTab
    @State private var widths: [ReportTopTab: CGFloat] = [:]

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 24) {
                ForEach(ReportTopTab.allCases, id: \.self) { tab in
                    Button(action: { withAnimation(.easeInOut(duration: 0.25)) { selected = tab } }) {
                        VStack(spacing: 0) {
                            Text(tab.rawValue)
                                .font(selected == tab ? .PretendardMedium18 : .PretendardMedium18)
                                .foregroundColor(selected == tab ? .grey06 : .grey02)
                                .fixedSize(horizontal: true, vertical: false)
                                .background(
                                    GeometryReader { proxy in
                                        Color.clear.preference(key: TabWidthKey.self, value: [tab: proxy.size.width])
                                    }
                                )
                                .overlay(alignment: .bottomLeading) {
                                    if selected == tab {
                                        Rectangle()
                                            .fill(Color.orange05)
                                            .frame(width: (widths[tab] ?? 0), height: 3)
                                            .offset(y: 6)
                                    }
                                }
                                .padding(.bottom, 8)
                        }
                        .contentShape(Rectangle())
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Rectangle().fill(Color.reportTextSecondary.opacity(0.15)).frame(height: 1)
        }
        .onPreferenceChange(TabWidthKey.self) { widths = $0 }
    }
}

struct ReportTopTabView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(ReportTopTab.all) { binding in
            ReportTopTabView(selected: binding)
                .padding()
                .background(Color.reportBackground)
        }
    }
}


