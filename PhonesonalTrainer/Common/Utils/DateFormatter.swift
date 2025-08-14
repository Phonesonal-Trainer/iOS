//
//  DateFormatter.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/8/25.
//

import Foundation

extension DateFormatter {
    static let dateOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}
