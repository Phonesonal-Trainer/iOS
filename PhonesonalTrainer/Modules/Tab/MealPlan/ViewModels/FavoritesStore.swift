//
//  FavoritesStore.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/14/25.
//

import Foundation

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var ids: Set<Int> = []

    func apply(foodId: Int, isFavorite: Bool) {
        if isFavorite { ids.insert(foodId) } else { ids.remove(foodId) }
    }

    func contains(_ foodId: Int) -> Bool { ids.contains(foodId) }
}
