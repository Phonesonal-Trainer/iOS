//
//  DurationSheetView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/17/25.
//

import SwiftUI

struct DurationSheetView: View {
    @Binding var selected: String
    @Binding var isPresented: Bool

    let options = ["1개월", "3개월", "6개월"]

    var body: some View {
        VStack(spacing: 0) {
            // 상단 타이틀 & 닫기 버튼
            HStack {
                Text("목표 기간을 선택해주세요.")
                    .font(.PretendardMedium20)
                    .padding()
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.grey06)
                        .padding()
                }
            }

            Divider()
                .background(Color.grey01) // Divider 색상 커스텀

            // 옵션 리스트
            VStack(spacing: 0) {
                ForEach(options.indices, id: \.self) { index in
                    Button(action: {
                        selected = options[index]
                        isPresented = false
                    }) {
                        Text(options[index])
                            .font(.PretendardMedium18)
                            .foregroundColor(.grey05)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }

                    // 마지막 옵션 아래에는 Divider 없음
                    if index < options.count - 1 {
                        Divider()
                            .background(Color.grey01) // Divider 색상 커스텀
                    }
                }
            }
        }
        .presentationDetents([.fraction(0.35)])
    }
}

#Preview {
    DurationSheetPreviewWrapper()
}

struct DurationSheetPreviewWrapper: View {
    @State private var selected = "1개월"
    @State private var isPresented = true

    var body: some View {
        DurationSheetView(selected: $selected, isPresented: $isPresented)
    }
}
