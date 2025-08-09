import SwiftUI

struct BodyPicView: View {
    @State private var showImagePickerOptions = false
    @State private var uploadedImage: UIImage? = nil
    @State private var showDeleteAlert = false
    @State private var isExpanded = true
    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 상단 제목 + 토글 버튼
            HStack {
                Text("눈바디")
                    .font(.system(size: 18))
                    .foregroundStyle(.grey05)

                Spacer()

                if uploadedImage != nil {
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }) {
                        Text(isExpanded ? "접기" : "펼치기")
                            .font(.system(size: 14))
                            .foregroundColor(.grey03)
                    }
                }
            }
            .frame(width: 300, height: 22)

            if uploadedImage != nil {
                if isExpanded {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: uploadedImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .cornerRadius(5)

                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 12))
                                Text("삭제")
                                    .font(.system(size: 12))
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .foregroundColor(.white)
                            .background(Color.grey05)
                            .cornerRadius(5)
                        }
                        .padding(8)
                    }
                } else {
                    // 접힌 상태에선 아무것도 보여주지 않음
                    EmptyView()
                }
            } else {
                // 이미지 없을 때만 업로드 버튼 보여줌
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
                .confirmationDialog("사진 선택", isPresented: $showImagePickerOptions) {
                    Button("카메라") {
                        pickerSource = .camera
                        showImagePicker = true
                    }
                    Button("사진 앨범") {
                        pickerSource = .photoLibrary
                        showImagePicker = true
                    }
                    Button("취소", role: .cancel) {}
                }
            }
        }
        .padding(20)
        .frame(width: 340)
        .background(Color.grey00)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .alert("사진을 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                uploadedImage = nil
                isExpanded = true
            }
            Button("취소", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: pickerSource, selectedImage: $uploadedImage)
        }
    }
}

#Preview {
    BodyPicView()
}
