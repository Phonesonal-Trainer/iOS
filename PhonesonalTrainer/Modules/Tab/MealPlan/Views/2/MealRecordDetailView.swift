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
        VStack(spacing: 0) {
            // 상단 타이틀 부분
            BackHeader(title: "\(mealType.rawValue) 식단 기록"){
                // 뒤로 가기 로직
            }
            .background(Color.grey00)
            .shadow(color: Color.black.opacity(0.1), radius: 2)
            .zIndex(1)
            .navigationBarBackButtonHidden(true)  // 기본 뒤로가기 버튼 숨기기 
            
            ScrollView {
                VStack(spacing: MealRecordDetailConstant.vSpacing) {
                    // 이미지 업로드 (서버에 업로드) -> 공용 컨포넌트로..?
                    ImageUpload()
                        .padding(.top, MealRecordDetailConstant.vSpacing)
                    
                    RecordInfoView()
                    
                    MealCheckListView()
                    
                    // 추가 식단
                }
                
            }
            .background(Color.background)
        }
    }
}


#Preview {
    MealRecordDetailView(mealType: .breakfast)
}
