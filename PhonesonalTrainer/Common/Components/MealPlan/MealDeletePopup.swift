//
//  MealDeletePopup.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/12/25.
//

import SwiftUI

struct MealDeletePopup: View {
    @ObservedObject var viewModel: AddedMealViewModel
    @Binding var isPresented: Bool
    let entry: MealRecordEntry
    var onFinish: () -> Void = {}
    
    // MARK: - 상수 정의
    fileprivate enum MealDeleteConstants {
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
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.grey00)
                .frame(width: MealDeleteConstants.width, height: MealDeleteConstants.height)
            
            VStack(spacing: MealDeleteConstants.VSpacing) {
                Image("AlertIcon")
                    .resizable()
                    .frame(width: MealDeleteConstants.imageSize, height: MealDeleteConstants.imageSize)
                
                textContent
                
                buttons
            }
        }
    }
    
    // MARK: - 텍스트
    private var textContent: some View {
        VStack(alignment: .center, spacing: MealDeleteConstants.textSpacing) {
            HStack(spacing: 0) {
                Text("정말")
                    .foregroundStyle(Color.grey06)
                Text(" 삭제")
                    .foregroundStyle(Color.orange05)
                Text("하시겠어요?")
                    .foregroundStyle(Color.grey06)
            }
            .font(.PretendardSemiBold22)
            
            Text("삭제 후 되돌릴 수 없어요.")
                .font(.PretendardMedium16)
                .foregroundStyle(Color.grey03)
        }
    }
    
    // MARK: - '취소' + '삭제하기' 버튼
    private var buttons: some View {
        HStack(spacing: MealDeleteConstants.HSpacing) {
            /// '취소' 버튼
            SubButton(color: .grey01, text: "취소", textColor: .grey05
            ) {
                /// 원래 화면으로 돌아가기
                isPresented = false
                onFinish()
            }
            .frame(width: MealDeleteConstants.buttonWidth)
            /// '그만하기' 버튼
            SubButton(color: .orange05, text: "삭제하기", textColor: .grey00
            ) {
                Task {
                    await viewModel.deleteMealRemote(entry)
                    isPresented = false
                    onFinish()
                }
            }
            .frame(width: MealDeleteConstants.buttonWidth)
            .disabled(viewModel.deleting.contains(entry.recordId))
        }
    }
}


