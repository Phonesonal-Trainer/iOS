//
//  LogoutPopup.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/10/25.
//

import SwiftUI

struct LogoutPopup: View {
    var onCancel: () -> Void
    var onRestart: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // 경고 아이콘
            HStack {
                Spacer()
                Image("logoutwarning")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 188)
                Spacer()
            }
            .padding(.top, 20)

            
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
            .padding(.bottom, 20)
        }
        .frame(width: 340, height: 136)
        .background(Color.grey00)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 2)
    }
}


#Preview {
    LogoutPopup(
        onCancel: {},
        onRestart: {}
    )
   // 딤 느낌만 살짝
}
