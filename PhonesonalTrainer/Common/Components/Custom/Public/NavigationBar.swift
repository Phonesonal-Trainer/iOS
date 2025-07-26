//
//  NavigationBar.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/25/25.
//

import SwiftUI

struct NavigationBar<Leading: View, Trailing: View>: View {
    var title: String?
    var leading: Leading
    var trailing: Trailing

    init(
        title: String? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.leading = leading()
        self.trailing = trailing()
    }

    var body: some View {
        HStack {
            // 왼쪽 버튼
            leading

            Spacer()

            // 타이틀이 있으면 가운데
            if let title = title {
                Text(title)
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
            }

            Spacer()

            // 오른쪽 버튼
            trailing
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.grey00)
    }
}

#Preview {
    VStack(spacing: 30) {
        NavigationBar(title: "프로필") {
            Button(action: { print("뒤로가기") }) {
                Image(systemName: "chevron.left")
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
            }
        }

        NavigationBar(title: "설정") {
            Button(action: { print("뒤로가기") }) {
                Image(systemName: "chevron.left")
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
            }
        } trailing: {
            Button("완료") {
                print("완료 클릭")
            }
            .font(.PretendardRegular18)
            .foregroundColor(.orange05)
        }
    }
    .padding()
    .background(Color.white)
}
