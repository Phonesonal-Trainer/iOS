//
//  PageIndicator.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

struct PageIndicator: View {
    let totalPages: Int
    let currentPage: Int
    let activeColor: Color
    let inactiveColor: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index <= currentPage ? activeColor : inactiveColor)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
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
