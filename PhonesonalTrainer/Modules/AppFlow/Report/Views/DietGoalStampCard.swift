import SwiftUI

struct DietGoalStampCard: View {
    let achievedDays: Set<DayOfWeek>

    var body: some View {
        CardContainer(background: .grey00) {
            VStack(alignment: .leading, spacing: 16) {
                Text("식단 목표 스탬프").font(.PretendardSemiBold18)
                HStack(spacing: 24) {
                    ForEach(DayOfWeek.ordered, id: \.self) { day in
                        let isAchieved = achievedDays.contains(day)
                        VStack(spacing: 8) {
                            ZStack {
                                if isAchieved {
                                    Image("식단목표스탬프")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.grey01)
                                        .frame(width: 30, height: 30)
                                }
                            
                            }
                            Text(day.displayShortKorean)
                                .font(.PretendardRegular14)
                                .foregroundColor(.grey05)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.orange02)
                    .overlay {
                        Text("지난 주 대비 목표 달성률이 현저하게 올랐네요!")
                            .font(.PretendardMedium12)
                            .foregroundColor(.grey05)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(height: 34)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct DietGoalStampCard_Previews: PreviewProvider {
    static var previews: some View {
        DietGoalStampCard(achievedDays: [.monday, .wednesday, .friday])
            .padding()
            .background(Color.reportBackground)
    }
}


