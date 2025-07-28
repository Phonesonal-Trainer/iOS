//
//  NutrientView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//

import SwiftUI

struct NutrientView: View {
    var carbs: Int
    var protein: Int
    var fat: Int

    var body: some View {
        HStack(spacing: 0) {
            nutrientColumn(title: "탄수화물", value: carbs)

            Spacer().frame(width: 25)
            dividerLine()
            Spacer().frame(width: 25)

            nutrientColumn(title: "단백질", value: protein)

            Spacer().frame(width: 25)
            dividerLine()
            Spacer().frame(width: 25)

            nutrientColumn(title: "지방", value: fat)
        }
        .frame(width: 256, height: 44)
    }

    private func nutrientColumn(title: String, value: Int) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 14)) // 네가 바꿔
                .foregroundColor(.grey03)
            Text("\(value)g")
                .font(.system(size: 18, weight: .semibold)) // 네가 바꿔
                .foregroundColor(.grey05)
        }
        .frame(width: 52)
    }

    private func dividerLine() -> some View {
        Rectangle()
            .fill(Color.grey01)
            .frame(width: 1, height: 30)
    }
}

#Preview {
    NutrientView(carbs: 111, protein: 111, fat: 111)
        .previewLayout(.sizeThatFits)
        .padding()
       
}
