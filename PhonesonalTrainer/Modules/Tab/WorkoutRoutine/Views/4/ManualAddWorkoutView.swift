//
//  ManualAddWorkoutView.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/2/25.
//

import SwiftUI
import UIKit

struct ManualAddWorkoutView: View {
    // MARK: - Property
    @EnvironmentObject var viewModel: WorkoutListViewModel
    @Environment(\.dismiss) var dismiss   // 뒤로가기
    
    // MARK: - 정의
    /// 입력 받는 정보 정의
    @State private var workoutName: String = ""
    @State private var kcalBurned: String = ""
    @State private var selectedCategory: WorkoutType? = nil
    @FocusState private var focusedField: Field?
    
    enum Field {
        case workoutName
        case kcalBurned
    }
    
    /// Double로 변환된 값
    private var kcalBurnedValue: Double? {
        Double(kcalBurned)
    }
    
    /// 운동명 조건
    @State private var lastValidWorkoutName: String = ""
    @State private var shakeCount: Int = 0
    private let allowedPattern = #"^[\p{Hangul}a-zA-Z\s]*$"#
    private let maxWorkoutNameLength = 20
    
    // MARK: - 상수 정의
    fileprivate enum ManualAddWorkoutConstants {
        static let baseWidth: CGFloat = 340  // 기본적으로 전부 적용되는 너비
        static let VSpacing: CGFloat = 25
        static let HSpacing: CGFloat = 20
        static let categoryHSpacing: CGFloat = 10
        static let categoryVSpacing: CGFloat = 15
        static let textFieldTopPadding: CGFloat = 25
        static let textFieldBottomPadding: CGFloat = 284
        static let noticeHeight: CGFloat = 60 // notice 이미지 높이
    }
    
    // MARK: - 유효성 검사
    var isFormValid: Bool {
        !workoutName.isEmpty && selectedCategory != nil
    }
    
    var addButtonColor: Color {
        isFormValid ? .grey05 : .grey01
    }
    
    var addButtonTextColor: Color {
        isFormValid ? .grey00 : .grey02
    }
    
    var body: some View {
        VStack(spacing: 0) {
            /// NavigationBar
            topTitle
                .background(Color.grey00)
                .shadow(color: Color.black.opacity(0.1), radius: 2)
                .zIndex(1)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: ManualAddWorkoutConstants.VSpacing) {
                    /// 텍스트 입력란 부분
                    VStack(spacing: ManualAddWorkoutConstants.VSpacing) {
                        /// '운동명'
                        workoutNameInput
                        
                        /// '칼로리 소모량' + '운동 유형'
                        HStack(spacing: ManualAddWorkoutConstants.HSpacing) {
                            kcalBurnedInput
                            
                            categorySelect
                        }
                    }
                    .padding(.top, ManualAddWorkoutConstants.textFieldTopPadding)
                    .padding(.bottom, ManualAddWorkoutConstants.textFieldBottomPadding)
                    .frame(width: ManualAddWorkoutConstants.baseWidth)
                    
                    notice
                    
                    SubButton(
                        color: addButtonColor,
                        text: "추가하기",
                        textColor: addButtonTextColor
                    ) {
                        if isFormValid, let category = selectedCategory {
                            viewModel.addRecordedWorkout(
                                name: workoutName,
                                category: category,
                                kcal: kcalBurnedValue
                            )
                            dismiss()
                        }
                    }
                    .disabled(!isFormValid)
                    .frame(width: ManualAddWorkoutConstants.baseWidth)
                }
            }
        }
        .background(Color.background)
    }
    
    // MARK: - NavigationBar
    private var topTitle: some View {
        NavigationBar(title: "직접 추가") {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.PretendardMedium22)
                    .foregroundColor(.grey05)
            }
        }
    }
    
    // MARK: - '운동명'
    private var workoutNameInput: some View {
        InputFieldView(title: {
            Text("운동명")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
            + Text(" *")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.orange05)
        }, placeholder: "운동명을 입력하세요.", text: $workoutName)
        .focused($focusedField, equals: .workoutName)
        // 🔽 입력 검증: 허용 외 입력 또는 길이 초과 시 "되돌리기 + 흔들림 + 햅틱"
        .onChange(of: workoutName) { newValue in        // ← iOS16/17 모두 동작(단일 파라미터)
            let okChars = newValue.range(of: allowedPattern, options: .regularExpression) != nil
            let okLength = newValue.count <= maxWorkoutNameLength

            if okChars && okLength {
                lastValidWorkoutName = newValue
            } else {
                workoutName = lastValidWorkoutName  // 되돌리기
                shakeCount += 1                     // 흔들기
                errorHaptic()                       // 햅틱
            }
        }
        .modifier(ShakeEffect(animatableData: CGFloat(shakeCount))) // 🔶 살짝 흔들기
        
    }
    
    // MARK: - '칼로리 소모량'
    private var kcalBurnedInput: some View {
        InputFieldView(title: {
            Text("칼로리 소모량")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
        }, placeholder: "", text: $kcalBurned, keyboardType: .numberPad, suffixText: "kcal")
        .focused($focusedField, equals: .kcalBurned)
    }
    
    // MARK: - '운동 유형' 선택
    private var categorySelect: some View {
        VStack(alignment: .leading, spacing: ManualAddWorkoutConstants.categoryVSpacing) {
            Text("운동 유형")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.grey06)
            + Text(" *")
                .font(.PretendardMedium18)
                .foregroundStyle(Color.orange05)
            
            HStack(spacing: ManualAddWorkoutConstants.categoryHSpacing) {
                ForEach(WorkoutType.allCases, id: \.self) { category in
                    CategorySelectButton(category: category, selectedCategory: $selectedCategory)
                }
            }
        }
    }
    
    // MARK: - Notice
    private var notice: some View {
        Image("addWorkoutNotice")
            .resizable()
            .frame(width: ManualAddWorkoutConstants.baseWidth, height: ManualAddWorkoutConstants.noticeHeight)
    }
}

// 흔들림 효과
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

// 에러 햅틱
func errorHaptic() {
    let gen = UINotificationFeedbackGenerator()
    gen.notificationOccurred(.error)
}

#Preview {
    ManualAddWorkoutView()
}
