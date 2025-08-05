//
//  NavigationBar.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/25/25.
//

import SwiftUI

struct NavigationBar<Leading: View, Trailing: View>: View {
    @Environment(\.dismiss) private var dismiss  // ✅ 뒤로가기 위해 사용

    var title: String?
    var leading: Leading
    var trailing: Trailing
    var hasDefaultBackAction: Bool  // ✅ 기본 뒤로가기 동작 여부

    init(
        title: String? = nil,
        hasDefaultBackAction: Bool = false, // 기본값은 false
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.hasDefaultBackAction = hasDefaultBackAction
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
                if hasDefaultBackAction {
                    // ✅ 기본 뒤로가기 버튼
                    Button(action: {
                        dismiss()
                    }) {
                        leading
                    }
                } else {
                    leading
                }

                Spacer()
                trailing
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 44)
        .padding(.bottom, 12)
        .background(Color.grey00)
    }
}


#Preview {
    VStack(spacing: 20) {
        // 기본 뒤로가기 동작이 있는 NavigationBar
        NavigationBar(title: "프로필", hasDefaultBackAction: true) {
            Image(systemName: "chevron.left")
                .foregroundColor(.grey05)
        }

        // 뒤로가기 + 오른쪽 완료 버튼이 있는 NavigationBar
        NavigationBar(title: "설정", hasDefaultBackAction: true) {
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
