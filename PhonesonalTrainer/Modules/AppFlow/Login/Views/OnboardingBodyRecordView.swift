//
//  OnboardingBodyRecordView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

struct OnboardingBodyRecordView: View {
    let currentWeek: Int = 0  // 예시 (0주차)
    let goalDuration: Duration = .sixMonths // 예시 (6개월)

    @State private var uploadedImage: UIImage? = nil

    var body: some View {
        ZStack {
            Color.grey00.ignoresSafeArea()

            VStack(spacing: 24) {
                // 상단 BackHeader (오른쪽에 SKIP 추가)
                BackHeader {
                    // 뒤로가기 로직
                    print("뒤로가기 버튼 클릭")
                } trailing: {
                    Button("SKIP") {
                        print("SKIP 버튼 클릭")
                    }
                    .font(.PretendardRegular20)
                    .foregroundColor(.grey03)
                }

                // 주차 텍스트 (Badge 스타일)
                Text("\(currentWeek)주차 눈바디 기록")
                    .font(.PretendardRegular14)
                    .foregroundColor(.orange05)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.orange05, lineWidth: 1)
                    )

                // 안내 문구
                VStack(spacing: 4) {
                    Text("\(goalDuration.rawValue) 간의 여정에 앞서")
                        .font(.PretendardRegular22)
                        .foregroundColor(.grey06)

                    Text("BEFORE 눈바디 기록")
                        .font(.PretendardSemiBold22)
                        .foregroundColor(.grey06)

                    Text("을 남겨볼까요?")
                        .font(.PretendardRegular22)
                        .foregroundColor(.grey06)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)

                Spacer()

                // 이미지 업로드 버튼 (공용)
                ImageUploadButton(
                    image: $uploadedImage,
                    isLocal: true
                )
                .padding(.bottom, 64)

                // 경고 문구
                HStack(alignment: .top, spacing: 6) {
                    Image("사진알림")
                }
                .padding(.horizontal)

                Spacer()

                // 기록하기 버튼 (SubButton)
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
        }
    }
}

#Preview {
    OnboardingBodyRecordView()
}
