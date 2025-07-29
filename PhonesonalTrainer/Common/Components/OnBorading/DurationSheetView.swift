//
//  DurationSheetView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/17/25.
//


import SwiftUI

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct DurationSheetView: View {
    @Binding var selected: Duration
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 0) {
            // 상단 타이틀 & 닫기 버튼
            HStack {
                Text("목표 기간을 선택해주세요.")
                    .font(.PretendardMedium20)
                    .foregroundStyle(Color.grey06)
                    .padding()
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.grey06)
                        .padding()
                }
            }

            // 옵션 리스트
            VStack(spacing: 0) {
                ForEach(Duration.allCases.indices, id: \.self) { index in
                    let option = Duration.allCases[index]
                    Button(action: {
                        selected = option
                        isPresented = false
                    }) {
                        Text(option.rawValue)
                            .font(.PretendardMedium18)
                            .foregroundStyle(Color.grey05)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }

                    if index < Duration.allCases.count - 1 {
                        Divider()
                            .background(Color.grey01)
                            .padding(.horizontal, 25)
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
        .padding(.horizontal, 8)
        .background(Color.grey00)
        .clipShape(RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
    }
}

#Preview {
    DurationSheetPreviewWrapper()
}

struct DurationSheetPreviewWrapper: View {
    @State private var selected: Duration = .oneMonth
    @State private var isPresented = true

    var body: some View {
        DurationSheetView(selected: $selected, isPresented: $isPresented)
    }
}
