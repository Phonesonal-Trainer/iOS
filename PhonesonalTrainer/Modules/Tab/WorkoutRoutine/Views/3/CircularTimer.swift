//
//  CircularTimer.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import SwiftUI

struct CircularTimer: View {
    let progress: Double
    let isPaused: Bool
    
    fileprivate enum C {
        static let hPadding: CGFloat = 75
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.orange02, lineWidth: 6)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.orange05, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
                // 일시정지면 애니메이션 없음
                .animation(isPaused ? nil : .linear(duration: 0.1), value: progress)
        }
        // .padding(.horizontal, C.hPadding)
    }
}

