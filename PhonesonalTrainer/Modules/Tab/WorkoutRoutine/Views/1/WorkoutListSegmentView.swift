//
//  WorkoutListSegmentView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/4/25.
//

import SwiftUI

struct WorkoutListSegmentView: View {
    @Binding var selectedTab: WorkoutTab
    @Namespace private var underlineAnimation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(WorkoutTab.allCases) { tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 4) {
                            Text(tab.rawValue)
                                .font(.PretendardMedium18)
                                .foregroundStyle(selectedTab == tab ? Color.grey06 : Color.grey02)
                            
                            // 선택된 항목 밑줄 (matchedGeometryEffect로 이동)
                            ZStack {
                                if selectedTab == tab {
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

