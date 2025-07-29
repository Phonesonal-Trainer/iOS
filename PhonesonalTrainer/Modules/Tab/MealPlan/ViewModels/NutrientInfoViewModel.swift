//
//  NutrientInfoViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/22/25.
//

/// 일단 임의로 넣어둔 코드... 나중에 백엔드로 받아서 다시 작성
import Foundation
import Combine

class NutrientInfoViewModel: ObservableObject {
    @Published var NutrientData: [NutrientInfoModel] = []

    func fetchNutrientInfo() {
        guard let url = URL(string: "https://api.yourserver.com/Nutrient") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode([NutrientInfoModel].self, from: data)
                    DispatchQueue.main.async {
                        self.NutrientData = decoded
                    }
                } catch {
                    print("디코딩 오류: \(error)")
                }
            } else if let error = error {
                print("네트워크 오류: \(error)")
            }
        }.resume()
    }
}
