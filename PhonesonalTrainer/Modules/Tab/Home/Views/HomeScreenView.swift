//
//  HomeView.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/15/25.
//
import SwiftUI

struct HomeView: View {
    @State private var showWeightPopup = false
    
    // 예시용 날짜
    let startDate = Date().addingTimeInterval(-60*60*24*30)
    let currentDate = Date()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 25) {
                    HomeHeaderView(startDate: startDate, currentDate: currentDate)
                    
                    TrainerCommentView()
                    
                    HomeTabView()
                    
                    DailyStatusView(onWeightTap: {
                        showWeightPopup = true
                    })
                    
                    BodyPicView()
                }
                .frame(width: 340)
                .padding(.vertical, 20)
            }
            
            // 팝업
            if showWeightPopup {
                Color("black00")
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                WeightPopupView(isPresented: $showWeightPopup)
            }
        }
    }
}
