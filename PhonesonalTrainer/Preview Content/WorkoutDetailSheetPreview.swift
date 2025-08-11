//
//  WorkoutDetailSheetPreview.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/12/25.
//

import SwiftUI

struct WorkoutDetailSheetPreview: View {
    @State private var isExpanded = false
    @State private var showYouTube = false
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Constants
    fileprivate enum SheetConstants {
        static let baseWidth: CGFloat = 340
        static let xButtonSize: CGFloat = 20
        /// 운동 방법
        static let stepCircleSize: CGFloat = 20
        static let stepMainSpacing: CGFloat = 10
        static let VSpacing: CGFloat = 15
        /// 유의사항
        static let alertIconSize: CGFloat = 18  // 유의사항 아이콘
        static let cautionTextSpacing: CGFloat = 10
        /// 유튜브 썸네일
        static let thumbHeight: CGFloat = 180
        static let iconWidth: CGFloat = 50
        static let iconHeight: CGFloat = 37
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("레그 프레스")
                            .font(.PretendardSemiBold22)
                            .foregroundStyle(Color.grey06)
                        
                        Spacer()
                        
                        // X 닫기 버튼
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundStyle(.grey06)
                                .frame(width: SheetConstants.xButtonSize, height: SheetConstants.xButtonSize)
                        }
                    }
                    Text("하체 (대퇴사두근, 햄스트링, 둔근")
                        .font(.PretendardMedium16)
                        .foregroundStyle(Color.grey03)
                }
                /// 이미지
                ZStack {
                    Rectangle().fill(Color.grey01)
                    Text("이미지 없음")
                        .font(.PretendardRegular12)
                        .foregroundStyle(Color.grey03)
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                /// 운동 방법
                DisclosureGroup("운동 방법", isExpanded: $isExpanded) {
                    VStack(alignment: .leading, spacing: SheetConstants.VSpacing) {
                        VStack {
                            HStack(alignment: .top, spacing: SheetConstants.stepMainSpacing) {
                                Text("1")
                                    .font(.PretendardMedium12)
                                    .foregroundStyle(Color.orange05)
                                    .background(
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .foregroundStyle(Color.orange02)
                                            .frame(width: SheetConstants.stepCircleSize, height: SheetConstants.stepCircleSize)
                                    )
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("등을 등받이에 밀착시키고 앉는다.")
                                        .font(.PretendardMedium16)
                                        .foregroundStyle(Color.grey06)
                                }
                            }
                        }
                        VStack {
                            HStack(alignment: .top, spacing: SheetConstants.stepMainSpacing) {
                                Text("2")
                                    .font(.PretendardMedium12)
                                    .foregroundStyle(Color.orange05)
                                    .background(
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .foregroundStyle(Color.orange02)
                                            .frame(width: SheetConstants.stepCircleSize, height: SheetConstants.stepCircleSize)
                                    )
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("발을 어깨 너비로 벌려 올린다.")
                                        .font(.PretendardMedium16)
                                        .foregroundStyle(Color.grey06)
                                    
                                    Text("이 때, 발끝은 살짝 바깥으로 향하도록 한다.")
                                        .font(.PretendardRegular14)
                                        .foregroundStyle(Color.grey03)
                                }
                            }
                        }
                    }
                    .frame(width: 300)
                }
                .font(.PretendardSemiBold18)
                .foregroundStyle(Color.grey06)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.grey00)
                        .shadow(color: Color.black.opacity(0.1), radius: 2)
                )
                .frame(width: 340)
            }
        }
    }
}

#Preview {
    WorkoutDetailSheetPreview()
}
