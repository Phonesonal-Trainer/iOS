//
//  KcalBurnedView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/4/25.
//

import SwiftUI

struct KcalBurnedView: View {
    @StateObject var kcalBurnedViewModel = CalorieProgressWorkoutViewModel(kcal: 1234, goal: 1234)
    
    fileprivate enum Constant {
        static let textLineSpacing: CGFloat = 5
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constant.textLineSpacing) {
            Text("총 소모 칼로리")
                .font(.PretendardRegular14)
                .foregroundStyle(Color.grey03)
            
            HStack {
                Text("\(kcalBurnedViewModel.kcal.formattedWithSeparator) kcal")
                    .font(.PretendardSemiBold22)
                    .foregroundStyle(Color.grey04)
                    .padding(.trailing, 8)
                
                Text("/ \(kcalBurnedViewModel.goal.formattedWithSeparator) kcal")
                    .font(.PretendardMedium16)
                    .foregroundStyle(Color.orange05)
            }
        }
    }
}

