//
//  CustomSearchBar.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/25/25.
//

/// 운동 검색
/// 식단 검색에 사용
import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    var placeholder: String  // placeholder 텍스트 외부에서 받음
    
    // MARK: - 상수 정의
    fileprivate enum SearchBarConstants {
        static let magnifyingglassIconSize: CGFloat = 24
        static let searchBarWidth: CGFloat = 340
        static let searchBarHeight: CGFloat = 44
    }
    
    var body: some View {
        
        HStack {
            TextField(placeholder, text: $text)
                .font(.PretendardMedium16)
                .foregroundStyle(Color.grey02)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.grey02)
                }
            }
            
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.grey05)
                .frame(width: SearchBarConstants.magnifyingglassIconSize, height: SearchBarConstants.magnifyingglassIconSize)
        }
        .padding(.horizontal)
        .frame(width: SearchBarConstants.searchBarWidth, height: SearchBarConstants.searchBarHeight)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.grey01)
                .frame(width: SearchBarConstants.searchBarWidth, height: SearchBarConstants.searchBarHeight)
        )
            
    }
}

