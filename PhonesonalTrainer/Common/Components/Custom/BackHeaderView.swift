//
//  BackHeaderView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/21/25.
//

import SwiftUI

struct BackHeaderView: View {
    var title: String? = nil         // 헤더 타이틀 (옵션)
    var onBack: () -> Void           // 뒤로가기 버튼 액션

    var body: some View {
        ZStack {
            // 중앙 타이틀
            if let title = title {
                Text(title)
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            // 왼쪽 뒤로가기 버튼
            HStack {
                Button(action: {
                    onBack()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.PretendardMedium22)
                        .foregroundColor(.grey05)
                }
                Spacer()
            }
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 20) {
        BackHeaderView {
            print("뒤로가기 버튼 클릭")
        }

        BackHeaderView(title: "프로필") {
            print("뒤로가기 버튼 클릭")
        }
    }
    .background(Color.white)
}
