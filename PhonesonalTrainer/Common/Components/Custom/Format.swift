//
//  Format.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/31/25.
//

import Foundation

// 소수점 아래가 0이면 생략, 0이 아니면 소수점 첫째자리까지 표시
func formatKcal(_ kcal: Double) -> String {
    if kcal.truncatingRemainder(dividingBy: 1) == 0 {
        return String(format: "%.0f", kcal)
    } else {
        return String(format: "%.1f", kcal)
    }
}

// 소수점 아래가 0이면 생략, 0이 아니면 소수점 둘째자리까지 표시
func formatToString(_ value: Double) -> String {
    if value.truncatingRemainder(dividingBy: 1) == 0 {
        return String(format: "%.0f", value)
    } else {
        return String(format: "%.2f", value)
    }
}
