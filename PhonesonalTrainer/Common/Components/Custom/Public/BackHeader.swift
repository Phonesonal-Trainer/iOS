//
//  BackHeader.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/21/25.
//

import SwiftUI

struct BackHeader<Content: View>: View {
    var title: String? = nil
    var onBack: () -> Void
    @ViewBuilder var trailing: () -> Content

    init(
        title: String? = nil,
        onBack: @escaping () -> Void,
        @ViewBuilder trailing: @escaping () -> Content = { EmptyView() } // 기본값 제공
    ) {
        self.title = title
        self.onBack = onBack
        self.trailing = trailing
    }

    var body: some View {
        HStack {
            Button(action: { onBack() }) {
                Image(systemName: "chevron.left")
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey06)
            }
            Spacer()
            if let title = title {
                Text(title)
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey06)
            }
            Spacer()
            trailing()
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 30) {
        BackHeader {
            print("뒤로가기 버튼 클릭")
        }

        BackHeader(title: "프로필") {
            print("뒤로가기 버튼 클릭")
        }

        BackHeader(title: "설정", onBack: {
            print("뒤로가기 버튼 클릭")
        }) {
            Button("완료") {
                print("완료 버튼 클릭")
            }
            .font(.PretendardRegular18)
            .foregroundColor(.orange05)
        }
    }
    .padding()
    .background(Color.white)
}
