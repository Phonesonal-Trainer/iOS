//
//  Duration.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/24/25.
//

import SwiftUI

/// 사용자가 선택할 수 있는 목표 기간
enum Duration: String, CaseIterable, Identifiable {
    case oneMonth = "1개월"
    case threeMonths = "3개월"
    case sixMonths = "6개월"

    var id: String { rawValue }
}
