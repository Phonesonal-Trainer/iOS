//
//  OnboradingStart.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//

import SwiftUI

struct OnboardingStartView: View {
    var body: some View {
        VStack(spacing: 40) {
            // 로고와 문구를 중앙 정렬
            VStack(spacing: 24) {
                Image("최종로고시안")
                    .resizable()
                    .frame(width: 180, height: 180)

                VStack(spacing: 4) {
                    Text("핸드폰 안에서 만나는")
                        .font(.PretendardRegular20)
                        .foregroundColor(.grey03)

                    HStack(spacing: 0) {
                        Text("나만의 ")
                            .font(.PretendardSemiBold22)
                            .foregroundColor(.grey06)
                        Text("폰스널 트레이너")
                            .foregroundColor(.orange05)
                            .font(.PretendardSemiBold22)
                    }
                }
            }
            
            .padding(.top, 64)

            Spacer() // 로그인 영역과 상단 간 간격

            // 로그인 버튼 영역 (중앙 정렬)
            VStack(spacing: 24) {
                Text("SNS 계정으로 간편 로그인하세요")
                    .font(.PretendardRegular14)
                    .foregroundColor(.grey03)

                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image("구글로그인")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }

                    Button(action: {}) {
                        Image("카카오로그인")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .padding(.bottom, 104)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    OnboardingStartView()
}
