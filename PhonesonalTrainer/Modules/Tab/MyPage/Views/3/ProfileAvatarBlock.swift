//
//  ProfileAvatarBlock.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/14/25.
//
// ProfileAvatarBlock.swift
import SwiftUI
import UIKit

struct ProfileAvatarBlock: View {
    let name: String   // 마이페이지에서 받은 name
    @EnvironmentObject var my: MyPageViewModel
    
    
    @State private var uploadedImage: UIImage? = nil
    @State private var showPickerOptions = false
    @State private var showPicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        VStack(spacing: 15) {
            ZStack(alignment: .bottomTrailing) {
                // 100x100 원형, 꽉 채움 (패딩 없음)
                Group {
                    if let img = uploadedImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                    } else if let ui = UIImage(named: "logo") {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(.systemGray4), lineWidth: 1))
                
                // 연필 버튼 (아이콘 24x24, 히트영역은 넓혀서 접근성 확보)
                Button { showPickerOptions = true } label: {
                    (UIImage(named: "edit").map(Image.init(uiImage:)) ?? Image(systemName: "pencil"))
                        .resizable()
                        .frame(width: 24, height: 24)     // ← 시각 사이즈 고정
                    
                        .clipShape(Circle())
                    
                }
                
            }
            
            // 이름
            VStack(spacing: 10) {
                Text(name.isEmpty ? "사용자" : name)
                    .font(.PretendardMedium20)
                    .foregroundColor(Color(.label))
                
                Button(action: {}) {
                    Text("구글 계정 연동")
                        .font(.PretendardRegular12)
                        .foregroundColor(.grey05)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(.grey01))
                        .clipShape(Capsule())
                }
            }
        }
        // 카메라/앨범 선택 팝업
        .confirmationDialog("프로필 사진", isPresented: $showPickerOptions, titleVisibility: .visible) {
            Button("카메라") { pickerSource = .camera; showPicker = true }
            Button("사진 앨범") { pickerSource = .photoLibrary; showPicker = true }
            if uploadedImage != nil {
                Button("사진 삭제", role: .destructive) { uploadedImage = nil }
            }
            Button("취소", role: .cancel) {}
        }
       
        .sheet(isPresented: $showPicker) {
            ImagePicker(sourceType: pickerSource, selectedImage: Binding(
                get: { my.avatarImage },
                set: { new in my.setAvatar(new) }
            )
            )
        }
    }
}

#Preview {
    ProfileAvatarBlock(name: "서연")
        .environmentObject(MyPageViewModel())
}
