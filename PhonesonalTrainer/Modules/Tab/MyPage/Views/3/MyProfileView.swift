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

    // ✅ @Published user.name 에 대한 Binding (로컬 @State 제거)
    private var nameBinding: Binding<String> {
        Binding(
            get: { user.name },
            set: { user.name = $0 }
        )
    }

    var body: some View {
        ZStack {
            Color.grey00.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {

                        // 1) 아바타 블록 (중앙 정렬) — 단일 소스: user.name
                        HStack {
                            Spacer()
                            ProfileAvatarBlock(name: user.name)
                            Spacer()
                        }

                        // 2) 구분 박스 (가로 꽉)
                        Rectangle()
                            .fill(Color.grey01)
                            .frame(height: 10)
                            .padding(.horizontal, -25)

                        // 3) 내 정보 — 표시용은 바인딩으로, 수정 버튼 콜백은 여기서 처리
                        MyInfoView(
                            name: nameBinding,
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

        // ✅ 목적지는 부모가 선언 (같은 스택에서 push)
        .navigationDestination(isPresented: $goEditName) {
            EditNameView(originalName: user.name) { newName in
                user.name = newName       // 단일 소스 업데이트 → 전 화면 즉시 반영
                // TODO: API updateName(newName)
            }
        }
        .navigationDestination(isPresented: $goEditHeight) {
            EditHeightView(originalHeight: 165) { newHeight in
                // TODO: height도 공통 VM 만들면 여기서 갱신
            }
        }
    }

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
            .environmentObject(UserProfileViewModel()) // ✅ 프리뷰에도 주입 필수
    }
}
