//
//  BodyPicView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//
import SwiftUI

struct BodyPicView: View {
    @State private var showImagePickerOptions = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("눈바디")
                .font(.system(size: 18))
                .foregroundStyle(.grey05)
                .frame(width: 300, height: 22, alignment: .leading)

            Button(action: {
                showImagePickerOptions = true
            }) {
                HStack(spacing: 5) {
                    Image("uploadIcon")
                        .resizable()
                        .frame(width: 16, height: 16)

                    Text("눈바디 업로드")
                        .font(.system(size: 14))
                        .foregroundStyle(.grey05)
                }
                .frame(width: 300, height: 42)
                .background(Color.grey01)
                .cornerRadius(5)
            }
            .confirmationDialog("사진 선택", isPresented: $showImagePickerOptions, titleVisibility: .visible) {
                Button("카메라") {
                    // TODO: 카메라 열기
                }
                Button("사진 업로드") {
                    // TODO: 앨범에서 사진 선택
                }
                Button("취소", role: .cancel) {}
            }
        }
        .padding(20)
        .frame(width: 340, height: 119)
        .background(Color.grey00)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    BodyPicView()
}
