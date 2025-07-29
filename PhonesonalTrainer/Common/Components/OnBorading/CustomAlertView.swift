//
//  CustomAlertView.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/28/25.
//


import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    var onDelete: () -> Void

    var body: some View {
        if isPresented {
            ZStack {
                // 배경 어둡게
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }

                VStack(spacing: 8) {
                    Image("AlertIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 42, height: 42)
                        .padding(.bottom, 8)

                    (
                        Text("정말 ")
                            .font(.PretendardSemiBold22)
                            .foregroundStyle(Color.grey06)
                        + Text("삭제")
                            .font(.PretendardSemiBold22)
                            .foregroundStyle(Color.orange05)
                        + Text("하시겠어요?")
                            .font(.PretendardSemiBold22)
                            .foregroundStyle(Color.grey06)
                    )
                    .multilineTextAlignment(.center)

                    Text("삭제한 사진은 복구할 수 없습니다.")
                        .font(.PretendardMedium16)
                        .foregroundStyle(Color.grey03)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)

                    HStack(spacing: 12) {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("취소")
                                .font(.PretendardSemiBold18)
                                .foregroundStyle(Color.grey05)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.grey01)
                                .cornerRadius(5)
                        }

                        Button(action: {
                            onDelete()
                            isPresented = false
                        }) {
                            Text("삭제")
                                .font(.PretendardSemiBold18)
                                .foregroundStyle(Color.grey00)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.orange05)
                                .cornerRadius(5)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: 340)
                .background(Color.grey00)
                .cornerRadius(10)
            }
            .transition(.opacity)
            .animation(.easeInOut, value: isPresented)
        }
    }
}

#Preview {
    StatefulPreviewWrapper(true) { isPresented in
        ZStack {
            Color.grey02.ignoresSafeArea()
            CustomAlertView(
                isPresented: isPresented,
                onDelete: { print("삭제 실행됨") }
            )
        }
    }
}
