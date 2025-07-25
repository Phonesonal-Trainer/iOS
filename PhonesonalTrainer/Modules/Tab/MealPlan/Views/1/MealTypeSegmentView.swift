//
//  MealTypeTabView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/15/25.
//

import SwiftUI

struct MealTypeSegmentView: View {
    @State private var selectedMeal: MealType = .breakfast
    @Namespace private var underlineAnimation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(MealType.allCases, id: \.self) { meal in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedMeal = meal
                        }
                    }) {
                        VStack(spacing: 4) {
                            Text(meal.segmentTitle)
                                .font(meal.segmentFont)
                                .foregroundColor(selectedMeal == meal ? .grey06 : .grey02)
                            
                            // 선택된 항목 밑줄 (matchedGeometryEffect로 이동)
                            ZStack {
                                if selectedMeal == meal {
                                    Rectangle()
                                        .fill(Color.orange05)
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "underline", in: underlineAnimation)
                                } else {
                                    Color.clear.frame(height: 2)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            
            // 전체 밑 회색 라인
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
        }
    }
}
#Preview {
    MealTypeSegmentView()
}
