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
    @State private var isUploading = false
    @State private var errorMessage: String?
    
    var isLocal: Bool = true        // 로컬 저장 여부 (기본값: 로컬)
    /// 업로드 실행 클로저: 이미지를 넘겨주면 서버 업로드를 수행 (필수)
    var onUpload: ((UIImage) async throws -> MealImageResponse)?
    /// 업로드 성공 후 후처리(선택): 서버 응답 result를 전달
    var onUploaded: ((MealImageResult) -> Void)?


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
            
            if let msg = errorMessage {
                Text(msg)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.top, 6)
            }
        }
        .onChange(of: selectedItem) {    // iOS 17 스타일
            if let newItem = selectedItem {
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        self.image = uiImage
                        print("📷 이미지 선택 완료 (로컬 저장: \(isLocal))")
                        if !isLocal {
                            await performUploadIfNeeded()
                        }
                    }
                }
            }
        }
    }
    
    // 내부 업로드 실행 (isLocal == false에서만 호출)
    private func performUploadIfNeeded() async {
        guard !isUploading else { return }
        guard let img = image else { return }
        guard let onUpload else {
            await MainActor.run { self.errorMessage = "업로드 핸들러가 설정되지 않았어요." }
            return
        }

        await MainActor.run {
            isUploading = true
            errorMessage = nil
        }
        defer { Task { @MainActor in isUploading = false } }

        do {
            let resp = try await onUpload(img)        // ① 서버 업로드
            guard resp.isSuccess else {
                throw NSError(domain: "UploadImage", code: -2,
                              userInfo: [NSLocalizedDescriptionKey: resp.message])
            }
            await MainActor.run {
                onUploaded?(resp.result)              // ② 후처리 콜백
            }
        } catch {
            await MainActor.run {
                errorMessage = "업로드 실패: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    ImageUploadButton(image: .constant(nil))
}
