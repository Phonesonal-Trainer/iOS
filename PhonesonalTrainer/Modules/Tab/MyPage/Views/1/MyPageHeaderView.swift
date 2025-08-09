//
//  my.profileview.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/10/25.
/// 상단 my & 프로필 버튼, 프로필 화살표 누르면 내 프로필 페이지 접근
// MyTopHeaderView.swift


// MyTopHeaderView.swift

import SwiftUI

struct MyPageHeaderView: View {
    let name: String              // "서연"
    let goalText: String          // "체중 감량"
    let durationText: String      // "3개월"
    let onChevronTap: () -> Void  // > 버튼 탭 액션
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 타이틀: 가운데 정렬
            VStack {
                Text("My")
                    .font(.PretendardMedium22)
                    .foregroundStyle(.grey05)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 16)
            
            // 프로필 요약 행
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(.grey01))
                    .frame(width: 65, height: 65)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(name)
                        .font(.PretendardSemiBold22)
                        .foregroundStyle(.grey06)
                    
                    GoalCapsuleTag(
                        goalText: goalText,
                        durationText: durationText
                    )
                }
                
                Spacer()
                
                Button(action: onChevronTap) {
                    Image(systemName: "chevron.right")
                      
                        .foregroundStyle(.grey02)
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

struct GoalCapsuleTag: View {
    let goalText: String
    let durationText: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image("goal") // 고정 아이콘
                .resizable()
                .frame(width: 16, height: 16)
            
            Text(goalText)
                .font(.PretendardRegular12)

                    Rectangle()
                        .fill(Color.orange02) // 토큰 컬러
                        .frame(width: 1, height: 8) // w=8, h=0 대신 h=1로 구현

                    Text(durationText)
                        .font(.PretendardRegular12)
        }
        .foregroundStyle(.grey05)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .overlay(
            Capsule().stroke(Color.orange05, lineWidth: 1)
        )
    }
}

#Preview {
    MyPageHeaderView(
        name: "서연",
        goalText: "체중 감량",
        durationText: "3개월",
        onChevronTap: {}
    )
}
