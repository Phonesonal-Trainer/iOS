//
//  OnboradingStart.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/16/25.
//

import SwiftUI
import KakaoSDKUser

struct OnboardingStartView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var navigateToNext = false
    @State private var navigateToMain = false
    @State private var showKakaoWebView = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                // 🔥 로고 및 문구 영역
                VStack(spacing: 24) {
                    Image("최종로고시안")
                        .resizable()
                        .frame(width: 180, height: 180)

                    VStack(spacing: 4) {
                        Text("핸드폰 안에서 만나는")
                            .font(.PretendardRegular20)
                            .foregroundStyle(Color.grey03)

                        HStack(spacing: 0) {
                            Text("나만의 ")
                                .font(.PretendardSemiBold22)
                                .foregroundStyle(Color.grey06)
                            Text("폰스널 트레이너")
                                .foregroundStyle(Color.orange05)
                                .font(.PretendardSemiBold22)
                        }
                    }
                }
                .padding(.top, 64)

                Spacer()

                // ✅ 로그인 버튼 영역
                VStack(spacing: 24) {
                    Text("SNS 계정으로 간편 로그인하세요")
                        .font(.PretendardRegular14)
                        .foregroundStyle(Color.grey03)

                    HStack(spacing: 16) {
                        // 구글 로그인 버튼 (미구현)
                        Button(action: {}) {
                            Image("구글로그인")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }

                        // ✅ 카카오 로그인 버튼 (WebView 방식)
                        Button(action: {
                            // ✅ 테스트 목적: 로그인 시작 시 온보딩 완료 플래그 초기화
                            hasCompletedOnboarding = false
                            showKakaoWebView = true
                        }) {
                            Image("카카오로그인")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }

                    // ❌ 로그인 실패 시 에러 출력
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
                    // ✅ 테스트용: 모든 사용자 온보딩 진입 강제
                    print("✅ 로그인 성공 · 온보딩 강제 이동")
                    navigateToNext = true
                }
            }
            // ✅ 로그인 성공 시 OnboardingInfoInputView로 이동
            .navigationDestination(isPresented: $navigateToNext) {
                // 모든 사용자를 온보딩으로 이동
                OnboardingInfoInputView(viewModel: {
                    let onboardingViewModel = OnboardingViewModel()
                    onboardingViewModel.tempToken = viewModel.tempToken
                    return onboardingViewModel
                }())
            }
            // 카카오 WebView 표시
            .sheet(isPresented: $showKakaoWebView) {
                KakaoLoginWebViewScreen(authViewModel: viewModel)
                    .onDisappear {
                        // ✅ 테스트용: WebView 닫힌 뒤에도 온보딩으로 고정
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            print("WebView 닫힘 - 로그인 상태: \(viewModel.isLoggedIn) → 온보딩 강제 이동")
                            if viewModel.isLoggedIn {
                                navigateToNext = true
                            }
                        }
                    }
            }
            // 기존 사용자 메인 이동
            .navigationDestination(isPresented: $navigateToMain) {
                MainTabView()
            }
        }
    }
}

#Preview {
    OnboardingStartView()
        .environmentObject(WorkoutListViewModel())
}
