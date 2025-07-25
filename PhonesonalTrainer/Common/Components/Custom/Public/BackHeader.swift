//
//  BackHeader.swift
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
        .padding(.top, BackHeaderConstants.topPadding)
        .padding(.horizontal, BackHeaderConstants.horizontalPadding)
        .padding(.bottom, BackHeaderConstants.bottomPadding)
    }
}

#Preview {
    VStack(spacing: 30) {
        BackHeader {
            print("뒤로가기 버튼 클릭")
        }

        BackHeader(title: "내 프로필") {
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
