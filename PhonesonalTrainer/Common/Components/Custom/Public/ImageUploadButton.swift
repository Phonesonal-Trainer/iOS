//
//  ImageUploadButton.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI
import PhotosUI

struct ImageUploadButton: View {
    @Binding var image: UIImage?    // 업로드할 이미지 (외부에서 Binding으로 주입)
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    var isLocal: Bool = true        // 로컬 저장 여부 (기본값: 로컬)

    var body: some View {
        VStack {
            Button(action: {
                showImagePicker = true
            }) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 200)
                        .cornerRadius(5)
                        .clipped()
                } else {
                    VStack(spacing: 16) {
                        Image("이미지업로드")
                        Text("이미지 업로드")
                            .font(.PretendardMedium18)
                            .foregroundColor(.grey03)
                    }
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .frame(width: 300, height: 200)
                    .background(Color.grey01)
                    .cornerRadius(5)
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $selectedItem)
            .onChange(of: selectedItem) {    // iOS 17 스타일
                if let newItem = selectedItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            self.image = uiImage
                            print("📷 이미지 선택 완료 (로컬 저장: \(isLocal))")
                            if !isLocal {
                                // 서버 업로드 로직 예시
                                print("서버로 업로드할 예정: \(uiImage)")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ImageUploadButton(image: .constant(nil))
}
