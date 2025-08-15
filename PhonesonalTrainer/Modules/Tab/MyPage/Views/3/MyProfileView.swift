//  MyProfileView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/14/25.
//

import SwiftUI

struct MyProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var user: UserProfileViewModel

    // 네비게이션 상태
    @State private var goEditName = false
    @State private var goEditHeight = false

    // 에러 얼럿 제어
    @State private var showError = false

    // ✅ 바인딩
    private var nameBinding: Binding<String> {
        .init(get: { user.name }, set: { user.name = $0 })
    }
    private var heightBinding: Binding<Int> {
        .init(get: { user.heightCm }, set: { user.heightCm = $0 })
    }

    var body: some View {
        ZStack {
            Color.grey00.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {

                        // 1) 아바타 블록
                        HStack {
                            Spacer()
                            ProfileAvatarBlock(name: user.name)
                            Spacer()
                        }

                        // 2) 구분 박스
                        Rectangle()
                            .fill(Color.grey01)
                            .frame(height: 10)
                            .padding(.horizontal, -25)

                        // 3) 내 정보
                        MyInfoView(
                            name: nameBinding,
                            heightCm: heightBinding,
                            age: user.age,
                            genderText: user.genderKo,
                            onTapEditName: { goEditName = true },
                            onTapEditHeight: { goEditHeight = true }
                        )
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 25)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)

        // 프로필 조회는 화면 들어올 때 한 번
        .task { await user.fetchProfile() }

        // 네비
        .navigationDestination(isPresented: $goEditName) {
            EditNameView(originalName: user.name) { newName in
                Task { await user.updateName(newName) }
            }
        }
        .navigationDestination(isPresented: $goEditHeight) {
            EditHeightView(originalHeight: user.heightCm) { newHeight in
                Task { await user.updateHeight(newHeight) }
            }
        }

        // 에러 얼럿
        .onChange(of: user.lastError) { _, err in
            showError = (err != nil)
        }
        .alert("실패", isPresented: $showError, presenting: user.lastError) { _ in
            Button("확인", role: .cancel) { }
        } message: { err in
            Text(err)
        }

        // 로딩 오버레이
        .overlay {
            if user.isLoading {
                ZStack {
                    Color.black.opacity(0.05).ignoresSafeArea()
                    ProgressView().scaleEffect(1.2)
                }
            }
        }
    }

    // ✅ body 바깥(동일 struct 스코프)에 있어야 함
    private var topBar: some View {
        ZStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.grey05)
                }
                Spacer()
            }
            Text("내 프로필")
                .font(.PretendardMedium22)
                .foregroundStyle(.grey06)
        }
        .padding(.horizontal, 25)
        .frame(height: 56)
        .background(Color.grey00)
    }
}

#Preview {
    NavigationStack {
        MyProfileView()
            .environmentObject(UserProfileViewModel()) // ✅ 프리뷰에도 주입
    }
}
