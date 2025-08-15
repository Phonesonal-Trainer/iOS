//
//  URLRequest.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import Foundation

extension URLRequest {
    mutating func addAuthToken() {
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}
