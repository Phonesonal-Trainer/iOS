import SwiftUI

struct EyeBodyCompareCard: View {
    @State private var selectedIndex: Int = 0 // 0: 지난주, 1: n주차
    var nWeekText: String = "0주차"

    var body: some View {
        CardContainer(background: .grey00) {
            VStack(alignment: .leading, spacing: 16) {
                Text("눈바디 비교")
                    .font(.PretendardSemiBold18)

                HStack(spacing: 10) {
                    ToggleButton(title: "지난주", isSelected: selectedIndex == 0) { selectedIndex = 0 }
                    ToggleButton(title: nWeekText, isSelected: selectedIndex == 1) { selectedIndex = 1 }
                }

                HStack(spacing: 24) {
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.grey01)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                        Text("이번주").font(.PretendardMedium16).foregroundColor(.grey05)
                    }
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.grey01)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                        Text("지난주").font(.PretendardMedium16).foregroundColor(.grey05)
                    }
                }
            }
        }
    }
}

private struct ToggleButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.PretendardMedium12)
                .foregroundColor(isSelected ? .grey00 : .grey02)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.grey05 : Color.grey01)
                .cornerRadius(18)
        }
    }
}

struct EyeBodyCompareCard_Previews: PreviewProvider {
    static var previews: some View {
        EyeBodyCompareCard()
            .padding()
            .background(Color.reportBackground)
    }
}


