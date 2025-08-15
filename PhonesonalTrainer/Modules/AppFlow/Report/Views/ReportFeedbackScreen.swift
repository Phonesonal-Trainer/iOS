import SwiftUI

private enum FeedbackSatisfaction: String { case none, yes, no }

struct ReportFeedbackScreen: View {
    @Environment(\.dismiss) private var dismiss

    @State private var workoutSatisfaction: FeedbackSatisfaction = .none
    @State private var mealSatisfaction: FeedbackSatisfaction = .none

    @State private var workoutReason: String? = nil
    @State private var mealReason: String? = nil

    @State private var isWorkoutReasonSheetPresented: Bool = false
    @State private var isMealReasonSheetPresented: Bool = false

    // 운동 루틴 사유
    private let workoutReasons: [String] = [
        "운동 종류가 너무 많아요",
        "운동 종류가 너무 적어요",
        "운동 강도가 너무 높아요",
        "운동 강도가 너무 낮아요",
        "제공되는 운동이 마음에 들지 않아요"
    ]

    // 식단 플랜 사유
    private let mealReasons: [String] = [
        "총 섭취량이 너무 적어요",
        "총 섭취량이 너무 많아요",
        "제공되는 음식이 마음에 들지 않아요"
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    feedbackCard(
                        title: "운동 루틴",
                        question: "이번 주차 운동 루틴이 만족스러우셨나요?",
                        selection: $workoutSatisfaction,
                        reason: $workoutReason,
                        onSelectReason: { isWorkoutReasonSheetPresented = true }
                    )

                    feedbackCard(
                        title: "식단 플랜",
                        question: "이번 주차 식단 플랜이 만족스러우셨나요?",
                        selection: $mealSatisfaction,
                        reason: $mealReason,
                        onSelectReason: { isMealReasonSheetPresented = true }
                    )
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
            }

            MainButton(color: submitButtonColors.background, text: submitButtonTitle, textColor: submitButtonColors.text) {
                // TODO: submit API 호출 성공 시 아래 상태 업데이트
                // 피드백 제출 완료 표시를 위해 배너 UI 전환 트리거
                NotificationCenter.default.post(name: .reportFeedbackSubmitted, object: nil)
                dismiss()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationTitle("3주차 피드백")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.grey05)
                }
            }
        }
        .sheet(isPresented: $isWorkoutReasonSheetPresented) {
            reasonSheet(title: "이유를 선택해주세요.", reasons: workoutReasons, selected: $workoutReason)
        }
        .sheet(isPresented: $isMealReasonSheetPresented) {
            reasonSheet(title: "이유를 선택해주세요.", reasons: mealReasons, selected: $mealReason)
        }
    }

    private var submitButtonTitle: String { "피드백 제출하기" }

    private var isAllAnswered: Bool {
        let workoutDone = workoutSatisfaction != .none && (workoutSatisfaction == .yes || workoutReason != nil)
        let mealDone = mealSatisfaction != .none && (mealSatisfaction == .yes || mealReason != nil)
        return workoutDone && mealDone
    }

    private var submitButtonColors: (background: Color, text: Color) {
        isAllAnswered ? (.orange05, .grey00) : (.orange01, .orange03)
    }

    @ViewBuilder
    private func feedbackCard(
        title: String,
        question: String,
        selection: Binding<FeedbackSatisfaction>,
        reason: Binding<String?>,
        onSelectReason: @escaping () -> Void
    ) -> some View {
        CardContainer(background: .grey00) {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.PretendardRegular16)
                    .foregroundColor(.orange05)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)

                Text(question)
                    .font(.PretendardMedium18)
                    .foregroundColor(.grey05)

                HStack(spacing: 12) {
                    subButton(title: "네", isSelected: selection.wrappedValue == .yes) { selection.wrappedValue = .yes }
                    subButton(title: "아니요", isSelected: selection.wrappedValue == .no) { selection.wrappedValue = .no }
                }

                if selection.wrappedValue == .no {
                    VStack(alignment: .center, spacing: 12) {
                        Text("어떤 점이 불만족스러우셨나요?")
                            .font(.PretendardMedium18)
                            .foregroundColor(.grey05)
                        reasonPicker(selected: reason.wrappedValue, action: onSelectReason)
                    }
                }
            }
        }
    }

    private func subButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.PretendardMedium16)
                .foregroundColor(isSelected ? .grey00 : .grey02)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(isSelected ? Color.orange05 : Color.grey01)
                .cornerRadius(5)
        }
    }

    private func reasonPicker(selected: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(selected ?? "선택")
                    .font(.PretendardRegular18)
                    .foregroundColor(.grey05)
                Spacer(minLength: 0)
                Image(systemName: "chevron.down")
                    .foregroundColor(.grey03)
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.grey02, lineWidth: 1)
            )
            .cornerRadius(5)
        }
    }

    private func reasonSheet(title: String, reasons: [String], selected: Binding<String?>) -> some View {
        // 동적 높이로 불필요한 하단 여백 제거
        let headerHeight: CGFloat = 56
        let rowHeight: CGFloat = 52
        let detentHeight: CGFloat = headerHeight + CGFloat(reasons.count) * rowHeight

        return VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text(title)
                    .font(.PretendardMedium20)
                    .foregroundColor(.grey06)
                    .padding(.top, 12)
                Spacer(minLength: 0)
                Button(action: {
                    if isWorkoutReasonSheetPresented { isWorkoutReasonSheetPresented = false }
                    if isMealReasonSheetPresented { isMealReasonSheetPresented = false }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.grey06)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(reasons.enumerated()), id: \.offset) { idx, item in
                        if idx > 0 { Divider().background(Color.grey01) }
                        Button(action: {
                            selected.wrappedValue = item
                            if isWorkoutReasonSheetPresented { isWorkoutReasonSheetPresented = false }
                            if isMealReasonSheetPresented { isMealReasonSheetPresented = false }
                        }) {
                            Text(item)
                                .font(.PretendardRegular18)
                                .foregroundColor(.grey05)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 14)
                        }
                    }
                }
            }
        }
        .presentationDetents([.height(detentHeight), .large])
        .presentationDragIndicator(.hidden)
    }
}

struct ReportFeedbackScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReportFeedbackScreen()
        }
        .padding()
        .background(Color.reportBackground)
    }
}


