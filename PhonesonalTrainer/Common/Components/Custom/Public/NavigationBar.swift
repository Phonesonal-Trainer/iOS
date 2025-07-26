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
            // 타이틀을 화면 중앙에 배치 (양쪽 여백과 관계없이 항상 중앙)
            if let title = title {
                Text(title)
                    .font(.PretendardMedium22)
                    .foregroundStyle(Color.grey06)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            // 좌우 버튼은 HStack으로 정렬
            HStack {
                leading
                Spacer()
                trailing
            }
            .padding(.horizontal, 16)
        }
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
                    .foregroundStyle(Color.grey06)
            }
        }

        NavigationBar(title: "설정") {
            Button(action: { print("뒤로가기") }) {
                Image(systemName: "chevron.left")
                    .font(.PretendardMedium22)
                    .foregroundStyle(Color.grey06)
            }
        } trailing: {
            Button("완료") {
                print("완료 클릭")
            }
            .font(.PretendardMedium16)
            .foregroundStyle(Color.grey05)
        }
    }
    .padding()
    .background(Color.grey00)
}
