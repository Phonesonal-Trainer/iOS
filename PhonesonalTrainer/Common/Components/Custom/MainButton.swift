//
//  MainButton.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/21/25.
//

import SwiftUI

/// 앱 전반에서 사용할 수 있는 공통 메인 버튼 컴포넌트 (테두리 둥근)
/// 배경 색상, 텍스트, 액션을 주입받아 재사용 가능
struct MainButton: View {
    
    // MARK: - Property
    
    /// 버튼 배경 색상
    let color: Color
    
    /// 버튼에 표시될 텍스트
    let text: String
    
    /// 텍스트 색상
    let textColor: Color
    
    /// 버튼 높이
    let height: CGFloat
    
    let cornerRadius: CGFloat
    
    /// 버튼이 눌렸을 때 실행할 액션 클로저
    let action: () -> Void
    
    /// 내부에서 사용하는 레이아웃 상수
    fileprivate enum MainButtonConstants {
        static let buttonHeight: CGFloat = 56      // 버튼 높이
        static let cornerRadius: CGFloat = 60      // 버튼 모서리 둥글기
    }
    
    // MARK: - Init
    
    /// 커스텀 버튼 생성자
    /// - Parameters:
    ///   - color: 버튼 배경색
    ///   - text: 버튼 안에 표시될 텍스트
    ///   - height: 버튼 높이
    ///   - action: 버튼 클릭 시 실행할 동작
    init(
        color: Color = Color.grey05,  // 기본 색상. (버튼 색 바꾸고 싶으면 호출할 때 color값 지정.)
        text: String,
        textColor: Color = Color.grey00,   // 기본 색상 지정.
        height: CGFloat = MainButtonConstants.buttonHeight,
        cornerRadius: CGFloat = MainButtonConstants.cornerRadius,
        action: @escaping () -> Void
    ) {
        self.color = color
        self.text = text
        self.textColor = textColor
        self.height = height
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                // 배경: 둥근 사각형 모양
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                
                // 버튼 텍스트
                Text(text)
                    .font(.PretendardMedium20)
                    .foregroundStyle(textColor)
            }
        })

    }
}

#Preview {
    MainButton(text: "다음", action: {
        print("next")
    })
}
