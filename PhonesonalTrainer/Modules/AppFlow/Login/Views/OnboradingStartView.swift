//
//  OnboradingStart.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//

import SwiftUI

struct OnboardingStartView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var navigateToNext = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                // 로고 및 문구 생략 ...

                Spacer()

                VStack(spacing: 24) {
                    Text("SNS 계정으로 간편 로그인하세요")
                        .font(.PretendardRegular14)
                        .foregroundStyle(Color.grey03)

                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image("구글로그인")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }

                        Button(action: {
                            viewModel.loginWithKakao()
                        }) {
                            Image("카카오로그인")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }

                    if let error = viewModel.loginError {
                        Text("로그인 실패: \(error)")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.bottom, 104)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.grey00)
            .onChange(of: viewModel.isLoggedIn) { loggedIn in
                if loggedIn {
                    navigateToNext = true
                }
            }
            .navigationDestination(isPresented: $navigateToNext) {
                OnboardingInfoInputView() // 👈 다음 뷰로 이동
            }
        }
    }
}


#Preview {
    OnboardingStartView()
}
