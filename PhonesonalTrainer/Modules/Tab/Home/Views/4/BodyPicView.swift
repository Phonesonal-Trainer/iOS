import SwiftUI
import UIKit

struct BodyPicView: View {
    @EnvironmentObject var bodyPhoto: BodyPhotoStore

    @State private var showImagePickerOptions = false
    @State private var showDeleteAlert = false
    @State private var isExpanded = true
    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary

    // 오늘 화면에 보여줄 이미지
    @State private var todayImage: UIImage? = nil
    // 피커에서 바인딩으로 받는 임시 이미지
    @State private var uploadedImage: UIImage? = nil
    
    

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 상단 제목 + 토글 버튼
            HStack {
                Text("눈바디")
                    .font(.system(size: 18))
                    .foregroundStyle(.grey05)

                Spacer()

                if todayImage != nil {
                    Button(action: { withAnimation { isExpanded.toggle() } }) {
                        Text(isExpanded ? "접기" : "펼치기")
                            .font(.system(size: 14))
                            .foregroundColor(.grey03)
                    }
                }
            }
            .frame(width: 300, height: 22)

            if let img = todayImage {
                if isExpanded {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                            .cornerRadius(5)

                        Button(action: { showDeleteAlert = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "xmark").font(.system(size: 12))
                                Text("삭제").font(.system(size: 12))
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .foregroundColor(.white)
                            .background(Color.grey05)
                            .cornerRadius(5)
                        }
                        .padding(8)
                    }
                }
            } else {
                // 오늘 사진 없을 때 업로드 버튼
                Button(action: { showImagePickerOptions = true }) {
                    HStack(spacing: 5) {
                        if UIImage(named: "uploadIcon") != nil {
                            Image("uploadIcon")
                                .resizable()
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.grey03)
                                .frame(width: 16, height: 16)
                        }
                        Text("눈바디 업로드")
                            .font(.system(size: 14))
                            .foregroundStyle(.grey05)
                    }
                    .frame(width: 300, height: 42)
                    .background(Color.grey01)
                    .cornerRadius(5)
                }
                .confirmationDialog("사진 선택", isPresented: $showImagePickerOptions) {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Button("카메라") { pickerSource = .camera; showImagePicker = true }
                    }
                    Button("사진 앨범") { pickerSource = .photoLibrary; showImagePicker = true }
                    Button("취소", role: .cancel) {}
                }
            }
        }
        .padding(20)
        .frame(width: 340)
        .background(Color.grey00)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .alert("오늘 사진을 삭제할까요?", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                bodyPhoto.deleteToday()
                todayImage = nil
                isExpanded = true
            }
            Button("취소", role: .cancel) {}
        }
        // ✅ 바인딩 버전 ImagePicker (클로저 아님)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: pickerSource, selectedImage: $uploadedImage)
        }
        // ✅ 피커에서 이미지가 채워지면 저장하고 오늘 이미지 갱신
        .onChange(of: uploadedImage) { new in
            if let img = new {
                bodyPhoto.saveToday(image: img)
                uploadedImage = nil         // 임시값 정리(선택)
                refreshToday()
            }
        }
        .onAppear { refreshToday() }
    }

    private func refreshToday() {
        todayImage = bodyPhoto.todayImage() // 날짜 바뀌면 자동으로 nil → 업로드 버튼 보임
    }
}


#Preview {
    BodyPicView()
        .environmentObject(BodyPhotoStore())
}
