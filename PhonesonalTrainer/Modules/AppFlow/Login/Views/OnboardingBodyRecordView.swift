//
//  OnboardingBodyRecordView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.


import SwiftUI

struct OnboardingBodyRecordView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @EnvironmentObject var bodyPhoto: BodyPhotoStore // ✅ BodyPhotoStore 주입

    let currentWeek: Int = 0
    let goalDuration: Duration = .sixMonths

    @State private var uploadedImage: UIImage? = nil
    @State private var showDeleteAlert = false
    @State private var navigateToHome = false
    @State private var dummyPath: [HomeRoute] = [] // ✅ HomeScreenView용 임시 path

    // ✅ API 상태 처리용
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                contentView
                    .navigationBarBackButtonHidden(true)

                // ✅ NavigationLink → Home 이동
                NavigationLink(
                    destination: HomeScreenView(path: $dummyPath),
                    isActive: $navigateToHome
                ) {
                    EmptyView()
                }
            }
        }
    }

    // MARK: - Content View
    private var contentView: some View {
        ZStack {
            Color.grey00.ignoresSafeArea()

            VStack(spacing: 0) {
                navigationBar
                mainBody
                recordButton
            }

            if showDeleteAlert {
                CustomAlertView(
                    isPresented: $showDeleteAlert,
                    onDelete: {
                        uploadedImage = nil
                    }
                )
            }
        }
    }

    // MARK: - NavigationBar
    private var navigationBar: some View {
        NavigationBar {
            Button(action: {
                print("뒤로가기 버튼 클릭")
            }) {
                Image(systemName: "chevron.left")
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
            }
        } trailing: {
            Button("SKIP") {
                print("SKIP 버튼 클릭")
            }
            .font(.PretendardRegular20)
            .foregroundStyle(Color.grey03)
        }
    }

    // MARK: - Main Body
    private var mainBody: some View {
        VStack(spacing: 24) {
            Text("\(currentWeek)주차 눈바디 기록")
                .font(.PretendardRegular14)
                .foregroundStyle(Color.orange05)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.orange05, lineWidth: 1)
                )
                .padding(.top, 8)

            (
                Text("\(goalDuration.rawValue) 간의 여정에 앞서\n")
                    .font(.PretendardRegular22)
                    .foregroundStyle(Color.grey06)
                + Text("BEFORE 눈바디 기록")
                    .font(.PretendardSemiBold22)
                    .foregroundStyle(Color.grey06)
                + Text("을 남겨볼까요?")
                    .font(.PretendardRegular22)
                    .foregroundStyle(Color.grey06)
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal)

            if let image = uploadedImage {
                uploadedImagePreview
            } else {
                ImageUploadButton(image: $uploadedImage, isLocal: true)
                    .padding(.vertical, 48)
            }

            HStack(alignment: .top, spacing: 6) {
                Image("사진알림")
            }

            Spacer()
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
    }

    // MARK: - 업로드된 이미지 프리뷰
    private var uploadedImagePreview: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: uploadedImage!)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIScreen.main.bounds.width - 40)
                .cornerRadius(5)

            Button(action: {
                showDeleteAlert = true
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "xmark")
                        .font(.PretendardRegular14)
                    Text("삭제")
                        .font(.PretendardRegular14)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .foregroundStyle(Color.grey00)
                .background(Color.grey05)
                .cornerRadius(5)
            }
            .padding(16)
        }
        .padding(.vertical, 24)
    }

    // MARK: - 기록하기 버튼
    private var recordButton: some View {
        VStack {
            if isLoading {
                ProgressView("가입 중...")
                    .padding(.bottom, 10)
            }

            SubButton(
                color: uploadedImage != nil ? .grey05 : .grey01,
                text: "기록하기",
                textColor: uploadedImage != nil ? .white : .grey02
            ) {
                if let image = uploadedImage {
                    isLoading = true
                    
                    // ✅ 1단계: 0주차 눈바디 로컬 저장
                    bodyPhoto.saveWeek0(image: image)
                    print("📸 0주차 눈바디 로컬 저장 완료")
                    
                    // ✅ 2단계: 회원가입 진행 (기존 로직 유지)
                    AuthService.shared.signup(with: viewModel, tempToken: viewModel.tempToken) { result in
                        DispatchQueue.main.async {
                            isLoading = false
                            switch result {
                            case .success:
                                print("🎉 회원가입 성공 및 0주차 눈바디 저장 완료")
                                navigateToHome = true
                            case .failure(let error):
                                print("❌ 회원가입 실패: \(error.localizedDescription) → 홈으로 이동")
                                // 회원가입 실패해도 이미지는 저장되었으므로 홈으로 이동
                                navigateToHome = true
                            }
                        }
                    }
                }
            }
            .disabled(uploadedImage == nil)
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .alert("회원가입 실패", isPresented: $showError) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    OnboardingBodyRecordView(viewModel: OnboardingViewModel())
}
