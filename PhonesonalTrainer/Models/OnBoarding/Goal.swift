//
//  Goal.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

/// 사용자가 선택할 수 있는 운동 목표
enum Goal: String, CaseIterable, Identifiable {
    case loseWeight = "체중감량"
    case escapeSkinnyFat = "마른비만 탈출"
    case bulkUp = "벌크업"

    var id: String { rawValue }

    var selectedColor: Color { .orange05 }
    var unselectedColor: Color { .grey01 }
    var selectedTextColor: Color { .grey00 }
    var unselectedTextColor: Color { .grey03 }

    var selectedFont: Font { .PretendardRegular18 }
    var unselectedFont: Font { .PretendardRegular18 }
}
