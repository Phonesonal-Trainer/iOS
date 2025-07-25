//
//  imageUpload.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/23/25.
//

import SwiftUI

struct ImageUpload: View {
    var body: some View {
        Button(action:{
            // 이미지 업로드 하기..?
        }) {
            // 이미지 업로드 (서버에 업로드) -> 공용 컨포넌트로..?
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.grey01)
                    .frame(width: 300, height: 200)  // 나중에 상수 정의 해서 CGFloat로
                
                VStack(spacing: 15) {  // 나중에 상수 정의 해서 CGFloat로 (contentVSpacing)
                    Image("uploadIcon")
                        .resizable()
                        .frame(width: 42, height: 42) // 나중에 상수 정의 해서 CGFloat로 (uploadIconSize)
                    
                    Text("이미지 업로드")
                        .font(.PretendardMedium18)
                        .foregroundStyle(Color.grey03)
                }
            }
        }
    }
}

#Preview {
    ImageUpload()
}
