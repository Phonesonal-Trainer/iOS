//
//  TrainerCommentView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//

import SwiftUI
struct TrainerCommentView: View {
    var comment: String = "어쩌구저쩌구코멘트" //더미 

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) { // 간격 5
                           HStack(spacing: 4) {
                    Image("trainercomment")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                    Text("폰스널트레이너의 코멘트")
                        .font(.system(size: 14))
                        .foregroundStyle(.orange05)
                }

                Text(comment)
                    .font(.system(size: 12))
                    .foregroundStyle(.grey06)
                    .padding(.top, 0)
            }
            .padding(.horizontal, 15)
                       .padding(.vertical, 15)
                       .frame(width: 340, height: 67, alignment: .leading)
                       .background(Color.orange01)
                       .cornerRadius(5)
                       .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
    }
}
#Preview {
    TrainerCommentView(comment: "오늘도 잘 하셨어요! 내일도 파이팅 💪")
}
