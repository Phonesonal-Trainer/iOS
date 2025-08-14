//
//  UserProfileViewModel.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/14/25.
//

import SwiftUI
import Combine

final class UserProfileViewModel: ObservableObject {
    @Published var name: String = "서연"

    // TODO: API 붙일 때 여기로
    // func fetchProfile() async throws { ... }
    // func updateName(_ newName: String) async throws { ... }
}
