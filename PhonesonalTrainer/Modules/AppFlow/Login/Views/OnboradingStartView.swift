//
//  OnboradingStart.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//


import SwiftUI

struct OnboardingStartView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 80)

            // 좌측 정렬 고정용 래퍼
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 28) {
                    // 로고
                    Image("PhonesonalTrainerLogo")
                        .resizable()
                        .frame(width: 100, height: 73)
                        .clipShape(Rectangle())
                        .background(Color.white)

                    // 문구
                    VStack(alignment: .leading, spacing: 8) {
                        Text("핸드폰 안에서 만나는")
                            .font(.PretendardRegular22)

                        HStack(spacing: 0) {
                            Text("나만의 ")
                                .font(.PretendardSemiBold26)
                            Text("퍼스널 트레이너")
                                .foregroundColor(.orange04)
                                .font(.PretendardSemiBold26)
                        }
                    }
                }
                Spacer() // 강제 왼쪽 정렬 역할
            }
            .padding(.leading, 40)

            Spacer()

            // 중앙 정렬되는 로그인 영역
            VStack(spacing: 24) {
                Text("SNS 계정으로 간편 로그인하세요")
                    .font(.PretendardRegular14)
                    .foregroundColor(.grey03)

                HStack(spacing: 30) {
                    Button(action: {}) {
                        Image("GoogleLogo")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .background(Color.grey01)
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .background(Color.grey01)
                            .clipShape(Circle())
                    }

                    Button(action: {}) {
                        Image("KakaoTalkLogo")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .background(Color.yellow0)
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .background(Color.yellow0)
                            .clipShape(Circle())
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 92)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    OnboardingStartView()
}
