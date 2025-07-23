//
//  PageIndicator.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

struct PageIndicator: View {
    let totalPages: Int          // 총 페이지 수
    let currentPage: Int         // 현재 활성 페이지
    let activeColor: Color       // 활성 캡슐 색
    let inactiveColor: Color     // 비활성 캡슐 색

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

#Preview {
    PageIndicator(
        totalPages: 4,
        currentPage: 0,
        activeColor: .orange05,
        inactiveColor: .grey01
    )
}
