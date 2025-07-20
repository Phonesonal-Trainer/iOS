//
//  DurationSheetView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/17/25.
//

import SwiftUI

struct DurationSheetView: View {
    @Binding var selected: String
    @Binding var isPresented: Bool

    let options = ["1개월", "3개월", "6개월"]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("목표 기간을 선택해주세요.")
                    .font(.PretendardSemiBold18)
                    .padding()
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding()
                }
            }

            Divider()

            ForEach(options, id: \.self) { option in
                Button(action: {
                    selected = option
                    isPresented = false
                }) {
                    Text(option)
                        .font(.PretendardRegular16)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }

            Spacer()
        }
        .presentationDetents([.fraction(0.35)])
    }
}
