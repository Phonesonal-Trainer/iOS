//
//  NutrientRow.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/28/25.
//


import SwiftUI

struct NutrientRow: View {
    // 이거 let으로 선언해도 되나
    @State var percentage: CGFloat
    let label: String
    let percentText: Int   // 이렇게 해도 되나ㅠ
    let gram: Int
    
    fileprivate enum NutrientRowConstants {
        static let width: CGFloat = 300
        static let height: CGFloat = 45
        static let VSpacing: CGFloat = 5
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            /// '탄수화물' + '30%'
            VStack(spacing: NutrientRowConstants.VSpacing) {
                /// 탄 / 단 / 지
                Text(label)
                    .font(.PretendardRegular12)
                    .foregroundStyle(Color.grey03)
                
                Text("\(percentText)%")
                    .font(.PretendardSemiBold16)
                    .foregroundStyle(Color.grey06)
            }
            
            Spacer()
            
            /// '11g'+ 퍼센트바
            VStack(alignment: .trailing, spacing: NutrientRowConstants.VSpacing) {
                Text("\(gram)g")
                    .font(.PretendardMedium12)
                    .foregroundStyle(Color.grey06)
                
                PercentBar(percentage: $percentage)
                    
                                    
            }
        }
        .frame(width: NutrientRowConstants.width, height: NutrientRowConstants.height)
    }
}

#Preview {
    NutrientRow(percentage: 0.3, label: "탄수화물", percentText: 30, gram: 11)
}
