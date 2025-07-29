//
//  OnboardingBodyRecordView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

struct OnboardingBodyRecordView: View {
    let currentWeek: Int = 0
    let goalDuration: Duration = .sixMonths

    @State private var uploadedImage: UIImage? = nil
    @State private var showDeleteAlert = false // 삭제 확인 Alert 상태

    var body: some View {
        NavigationStack {
            ZStack {
                Color.grey00.ignoresSafeArea()

                VStack(spacing: 0) {
                    // NavigationBar
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

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // 주차 텍스트
                            Text("\(currentWeek)주차 눈바디 기록")
                                .font(.PretendardRegular14)
                                .foregroundStyle(Color.orange05)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.orange05, lineWidth: 1)
                                )
                                .padding(.top, 4)

                            // 안내 문구
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

                            // 이미지 업로드 or 미리보기
                            if let image = uploadedImage {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: UIScreen.main.bounds.width - 40)
                                        .cornerRadius(5)

                                    // 삭제 버튼
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
                                        .foregroundStyle(Color.grey05)
                                        .cornerRadius(5)
                                    }
                                    .padding(16)
                                }
                                .padding(.vertical, 32)
                            } else {
                                ImageUploadButton(
                                    image: $uploadedImage,
                                    isLocal: true
                                )
                                .padding(.vertical, 96)
                            }

                            // 경고 문구
                            HStack(alignment: .top, spacing: 6) {
                                Image("사진알림")
                            }
                        }
                        .padding(.bottom, 120)
                    }

                    // 기록하기 버튼
                    SubButton(
                        color: uploadedImage != nil ? .grey05 : .grey01,
                        text: "기록하기",
                        textColor: uploadedImage != nil ? .white : .grey02
                    ) {
                        if uploadedImage != nil {
                            print("기록하기 버튼 클릭")
                        }
                    }
                    .disabled(uploadedImage == nil)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }

                // 커스텀 Alert
                CustomAlertView(
                    isPresented: $showDeleteAlert,
                    onDelete: {
                        uploadedImage = nil
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    OnboardingBodyRecordView()
}
