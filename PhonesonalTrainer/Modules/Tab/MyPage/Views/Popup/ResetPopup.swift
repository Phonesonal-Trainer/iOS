//
//  ResetPopup.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/10/25.
//


import SwiftUI

struct ResetPopup: View {
    var onCancel: () -> Void
    var onRestart: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 경고 아이콘
            HStack {
                Spacer()
                Image("warning")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                Spacer()
            }
            .padding(.top, 16)

            // 경고 문구
            HStack {
                Spacer()
                Image("reset warning")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 55) // 디자인 비율 맞게 조절
                Spacer()
            }
            .padding(.top, 12)

            // 버튼
            HStack(spacing: 10) {
                Button(action: onCancel) {
                    Text("취소")
                        .font(.PretendardSemiBold18)
                        .frame(width: 145, height: 50)
                        .background(Color.grey01)
                        .foregroundColor(.grey05)
                        .cornerRadius(5)
                }

                Button(action: onRestart) {
                    Text("재시작")
                        .font(.PretendardSemiBold18)
                        .frame(width: 145, height: 50)
                        .background(Color.orange05)
                        .foregroundColor(.grey00)
                        .cornerRadius(5)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
        }
        .frame(width: 340)
        .background(Color.grey00)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}


#Preview {
    ResetPopup(
        onCancel: {},
        onRestart: {}
    )
   // 딤 느낌만 살짝
}
