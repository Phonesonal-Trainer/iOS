//
//  BackHeaderView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/21/25.
//

import SwiftUI

struct BackHeaderView: View {
    var onBack: () -> Void  // 뒤로가기 버튼 액션

    var body: some View {
        HStack {
            Button(action: {
                onBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.grey05)
            }
            Spacer()
        }
        .padding(.top, 12)
    }
}

#Preview {
    BackHeaderView {
        print("뒤로가기 버튼 클릭")
    }
}
