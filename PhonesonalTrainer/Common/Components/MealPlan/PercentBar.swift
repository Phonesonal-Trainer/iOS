//
//  PercentBar.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/28/25.
//

import SwiftUI

struct PercentBar: View {
    // MARK: - Property
    @Binding var percentage: CGFloat
    
    fileprivate enum PercentBarConstants {
        static let width: CGFloat = 240  // 퍼센트바의 길이
        static let height: CGFloat = 15
        static let CRadius: CGFloat = 60
    }
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: PercentBarConstants.CRadius)
                .frame(width: PercentBarConstants.width, height: PercentBarConstants.height)
                .foregroundStyle(Color.grey01)
            
            RoundedRectangle(cornerRadius: PercentBarConstants.CRadius)
                .frame(width: PercentBarConstants.width * percentage, height: PercentBarConstants.height)
                .foregroundStyle(Color.orange05)
        }
    }
}


