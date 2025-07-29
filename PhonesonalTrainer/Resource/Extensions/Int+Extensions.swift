//
//  Int+Extensions.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 7/28/25.
//
import SwiftUI
import Foundation

extension Int {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
