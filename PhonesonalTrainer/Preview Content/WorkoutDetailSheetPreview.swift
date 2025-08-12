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
        static let chevronSize: CGFloat = 16
        static let VHPadding: CGFloat = 20
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
            VStack(spacing: SheetConstants.VSpacing) {
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
                .frame(width: SheetConstants.baseWidth)
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
                // 헤터 (토글 버튼)
                VStack(spacing: 0) {
                Button {
                    withAnimation(.easeInOut(duration: 0.6)) { isExpanded.toggle()}  // 애니메이션 넣을지 말지 고민...
                } label: {
                    HStack {
                        Text("운동 방법")
                            .font(.PretendardSemiBold18)
                            .foregroundStyle(Color.grey06)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .frame(width: SheetConstants.chevronSize)
                            .foregroundStyle(Color.grey03)
                    }
                }
                .padding(.horizontal, SheetConstants.VHPadding)
                .padding(.vertical, SheetConstants.VHPadding)
                .contentShape(Rectangle()) // 탭 영역 확대
                
                if isExpanded {
                            VStack {
                                // === 여기부터 네가 만든 스텝 UI ===
                                VStack(alignment: .leading, spacing: 16) {
                                    // Step 1
                                    HStack(alignment: .top, spacing: SheetConstants.stepMainSpacing) {
                                        ZStack {
                                            Circle().fill(Color.orange02).frame(width: SheetConstants.stepCircleSize, height: SheetConstants.stepCircleSize)
                                            Text("1")
                                                .font(.PretendardMedium12)
                                                .foregroundStyle(Color.orange05)
                                        }
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text("등을 등받이에 밀착시키고 앉는다.")
                                                .font(.PretendardMedium16)
                                                .foregroundStyle(Color.grey06)
                                        }
                                    }
                                    // Step 2
                                    HStack(alignment: .top, spacing: SheetConstants.stepMainSpacing) {
                                        ZStack {
                                            Circle().fill(Color.orange02).frame(width: SheetConstants.stepCircleSize, height: SheetConstants.stepCircleSize)
                                            Text("2")
                                                .font(.PretendardMedium12)
                                                .foregroundStyle(Color.orange05)
                                        }
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
                                // === 여기까지 스텝 UI ===
                            }
                            .padding(.horizontal, SheetConstants.VHPadding)
                            .padding(.bottom, SheetConstants.VHPadding)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.grey00)
                            .shadow(color: .black.opacity(0.1), radius: 2)
                    )
                    .padding(.top, 15)
                     // 바깥 여백이 필요하면
            
                VStack(alignment: .leading, spacing: SheetConstants.VSpacing) {
                    HStack(spacing: 0) {
                        Image("AlertIcon2")
                            .resizable()
                            .frame(width: SheetConstants.alertIconSize, height: SheetConstants.alertIconSize)
                            .padding(.trailing, 5)
                        
                        Text("유의사항")
                            .font(.PretendardSemiBold14)
                            .foregroundStyle(Color.grey03)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: SheetConstants.cautionTextSpacing) {
                        HStack {
                            Text("•")
                                .foregroundStyle(Color.grey02)
                            Text("무릎이 안쪽으로 모이지 않도록 유의하세요.")
                                .foregroundStyle(Color.grey03)
                                .multilineTextAlignment(.leading)
                        }
                        .font(.PretendardMedium12)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.horizontal, SheetConstants.VHPadding)
                .padding(.vertical, SheetConstants.VHPadding)
                
                .background(Color.orange01)
                .cornerRadius(5)
                
                /// 유튜브 썸네일
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(Color.grey01)
                    HStack(spacing: 8) {
                        Image(systemName: "play.rectangle.fill")
                            .foregroundStyle(.red)
                        Text("동영상 보기")
                            .font(.PretendardMedium12)
                            .foregroundStyle(Color.grey05)
                    }
                    
                }
                
                .frame( height: SheetConstants.thumbHeight)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 25)
            
            
        }
    }
}

#Preview {
    WorkoutDetailSheetPreview()
}
