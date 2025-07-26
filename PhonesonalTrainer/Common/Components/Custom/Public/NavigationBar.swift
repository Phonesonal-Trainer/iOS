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
        ZStack {
            // 타이틀 (중앙에 고정)
            if let title = title {
                Text(title)
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            // 좌우 버튼
            HStack {
                leading
                Spacer()
                trailing
            }
            .padding(.horizontal, 16) // 좌우 여백 통일
        }
        .frame(height: 44) // NavigationBar 기본 높이
        .padding(.bottom, 12) // 하단 여백 추가
        .background(Color.grey00)
    }
}

#Preview {
    VStack(spacing: 20) {
        NavigationBar(title: "프로필") {
            Image(systemName: "chevron.left")
                .foregroundColor(.grey05)
        }
        NavigationBar(title: "설정") {
            Image(systemName: "chevron.left")
                .foregroundColor(.grey05)
        } trailing: {
            Button("완료") { print("완료") }
                .font(.PretendardRegular18)
                .foregroundColor(.orange05)
        }
    }
    .padding()
    .background(Color.white)
}
