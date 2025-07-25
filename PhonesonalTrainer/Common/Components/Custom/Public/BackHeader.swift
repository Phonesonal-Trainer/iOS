//
//  BackHeaderView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/21/25.
//

import SwiftUI

struct BackHeader: View {
    var title: String? = nil         // 헤더 타이틀 (옵션)
    var onBack: () -> Void           // 뒤로가기 버튼 액션
    
    // MARK: - 상수 정의
    fileprivate enum BackHeaderConstants {
        static let topPadding: CGFloat = 15
        static let horizontalPadding: CGFloat = 25
        static let bottomPadding: CGFloat = 20
    }

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
        .padding(.top, BackHeaderConstants.topPadding)
        .padding(.horizontal, BackHeaderConstants.horizontalPadding)
        .padding(.bottom, BackHeaderConstants.bottomPadding)
    }
}

#Preview {
    VStack(spacing: 20) {
        BackHeader {
            print("뒤로가기 버튼 클릭")
        }

        BackHeader(title: "내 프로필") {
            print("뒤로가기 버튼 클릭")
        }
    }
    .background(Color.white)
}
