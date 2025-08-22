//
//  BodyWeightStore.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 8/22/25.
//

import Foundation

// API가 연결되지 않아 더미 데이터를 사용합니다.
private var dummyCurrentWeight = DummyData.currentWeight

@MainActor
final class BodyWeightStore: ObservableObject {
    @Published var currentWeight: Double = 0.0
    @Published var goalWeight: Double = 0.0
    @Published private(set) var userId: Int = 0   // ✅ userId 저장
    
    // ✅ 앱 최초 실행 시 userId 주입용
    func configure(userId: Int) {
        self.userId = userId
        Task {
            await refresh()
        }
    }
    
    // API 호출 대신 더미 데이터를 사용하여 데이터를 새로고침합니다.
    func refresh() async {
        // 더미 데이터에서 현재 몸무게를 가져와 업데이트
        self.currentWeight = dummyCurrentWeight
        
        // 홈 화면 더미 데이터에서 목표 몸무게를 가져와 Double로 변환하여 업데이트
        self.goalWeight = Double(DummyData.homeMainResult.main.targetWeight)
    }
    
    // API 호출 대신 더미 데이터를 업데이트합니다.
    func save(_ newWeight: Double) async -> Bool {
        // 더미 몸무게 값을 업데이트
        dummyCurrentWeight = newWeight
        
        // 업데이트된 더미 데이터를 반영하기 위해 새로고침 함수 호출
        await refresh()
        
        // 저장 성공으로 가정
        return true
    }
}
