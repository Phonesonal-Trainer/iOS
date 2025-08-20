//
//  URLRequest.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import Foundation

extension URLRequest {
    mutating func addAuthToken() {
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if let access = UserDefaults.standard.string(forKey: "accessToken"), !access.isEmpty {
            self.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")
        }
    }
}
