//
//  StopWorkoutPopup.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/3/25.
//

import SwiftUI

struct StopWorkoutPopup: View {
    @Binding var isPresented: Bool   // 팝업창 닫기
    
    // MARK: - 상수 정의
    fileprivate enum StopPopupConstants {
        static let width: CGFloat = 340
        static let height: CGFloat = 227
        static let VSpacing: CGFloat = 20
        static let HSpacing: CGFloat = 20
        static let textSpacing: CGFloat = 10
        static let imageSize: CGFloat = 42
        static let buttonWidth: CGFloat = 145
    }
    
    // MARK: - Body
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grey00)
                .frame(width: StopPopupConstants.width, height: StopPopupConstants.height)
            
            VStack(spacing: StopPopupConstants.VSpacing) {
                image
                
                textContent
                
                buttons
            }
        }
    }
    
    // MARK: - 이미지
    private var image: some View {
        Image("AlertIcon")
            .resizable()
            .frame(width: StopPopupConstants.imageSize, height: StopPopupConstants.imageSize)
    }
    
    // MARK: - 텍스트
    private var textContent: some View {
        VStack(alignment: .center, spacing: StopPopupConstants.textSpacing) {
            HStack(spacing: 0) {
                Text("정말")
                    .foregroundStyle(Color.grey06)
                Text(" 그만")
                    .foregroundStyle(Color.orange05)
                Text("하시겠어요?")
                    .foregroundStyle(Color.grey06)
            }
            .font(.PretendardSemiBold22)
            
            Text("현재 진행 중인 세트는 저장되지 않아요.")
                .font(.PretendardMedium16)
                .foregroundStyle(Color.grey03)
        }
    }
    
    // MARK: - '취소' + '그만하기' 버튼
    private var buttons: some View {
        HStack(spacing: StopPopupConstants.HSpacing) {
            /// '취소' 버튼
            SubButton(
                color: .grey01,
                text: "취소",
                textColor: .grey05
            ) {
                /// 원래 화면으로 돌아가기
                isPresented = false
            }
            .frame(width: StopPopupConstants.buttonWidth)
            /// '그만하기' 버튼
            SubButton(
                color: .orange05,
                text: "그만하기",
                textColor: .grey00
            ) {
                // 지금까지 운동하던거 그만하고 첫 화면으로 돌아가기... path.append..?
            }
            .frame(width: StopPopupConstants.buttonWidth)
        }
    }
}


