//
//  MealRecordDetailView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/23/25.
//

import SwiftUI

struct MealRecordDetailView: View {
    // MARK: - Property
    let mealType: MealType // 이거 말고 model 이나 viewmodel을 넣어야 될 것 같긴해
    @Environment(\.dismiss) private var dismiss  // 뒤로가기 액션
    
    // MARK: - 상수 정의
    fileprivate enum MealRecordDetailConstant {
        static let basicWidth: CGFloat = 340
        static let vSpacing: CGFloat = 25
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            // 상단 타이틀 부분
            HStack {
                BackHeader {
                    dismiss()
                }
                
                topTitle
                
                Spacer()
            }
            .frame(width: MealRecordDetailConstant.basicWidth)
            .navigationBarBackButtonHidden(true)  // 기본 뒤로가기 버튼 숨기기
            
            ScrollView {
                VStack(spacing: MealRecordDetailConstant.vSpacing) {
                    // 이미지 업로드 (서버에 업로드) -> 공용 컨포넌트로..?
                    ImageUpload()
                    
                    RecordInfoView()
                    
                    MealCheckListView()
                }
                
            }
            
            
            
            
        }
        
    }
    
    // MARK: - 제목
    private var topTitle: some View {
        Text("\(mealType.rawValue) 식단 기록")
            .font(.PretendardMedium22)
            .foregroundStyle(Color.grey06)
    }
    
    
}


#Preview {
    MealRecordDetailView(mealType: .breakfast)
}
