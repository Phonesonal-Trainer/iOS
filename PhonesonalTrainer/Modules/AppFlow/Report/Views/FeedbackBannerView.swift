import SwiftUI

struct FeedbackBannerView: View {
    let isVisible: Bool
    let action: () -> Void
    var isSubmitted: Bool = false

    var body: some View {
        if isVisible {
            Button(action: action) {
                HStack(spacing: 16) {
                    ZStack {
                        Image(isSubmitted ? "확인된피드백아이콘" : "피드백아이콘")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        if isSubmitted {
                            Text("이번주의 운동과 식단은 어땠나요?")
                                .font(.PretendardMedium12)
                                .foregroundStyle(Color.grey02)
                            Text("이번주 피드백 확인하기")
                                .font(.PretendardSemiBold16)
                                .foregroundStyle(Color.grey00)
                        } else {
                            Text("이번주의 운동과 식단은 어땠나요?")
                                .font(.PretendardMedium12)
                                .foregroundStyle(Color.orange02)
                            Text("이번주 피드백 남기기")
                                .font(.PretendardSemiBold16)
                                .foregroundStyle(Color.grey00)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(isSubmitted ? Color.grey06 : Color.orange05)
                .cornerRadius(5)
            }
        }
    }
}

struct FeedbackBannerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            FeedbackBannerView(isVisible: true, action: {}, isSubmitted: false)
            FeedbackBannerView(isVisible: true, action: {}, isSubmitted: true)
        }
        .padding()
        .background(Color.reportBackground)
    }
}


