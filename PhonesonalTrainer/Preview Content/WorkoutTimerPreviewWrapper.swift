//
//  WorkoutTimerPreviewWrapper.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import SwiftUI

// 목 데이터 팩토리
private enum WorkoutMockFactory {
    static func makeAnaerobic(
        id: Int,
        name: String,
        sets: Int,
        count: Int,
        weight: Int
    ) -> WorkoutModel {
        let exerciseSets: [ExerciseSet] = (1...sets).map { idx in
            ExerciseSet(
                setId: id * 100 + idx,
                setNumber: idx,
                count: count,
                weight: weight,
                completed: false
            )
        }
        return WorkoutModel(
            id: id,
            exerciseId: id,
            name: name,
            bodyPart: .unknown,
            muscleGroups: [],
            category: .anaerobic,
            status: .inProgress,
            kcalBurned: nil,
            exerciseSets: exerciseSets
        )
    }

    static func makeAerobic(
        id: Int,
        name: String,
        minutes: Int
    ) -> WorkoutModel {
        // 유산소도 프리뷰용으로 1세트만 생성
        let exerciseSets: [ExerciseSet] = [
            ExerciseSet(
                setId: id * 100 + 1,
                setNumber: 1,
                count: minutes,    // 분 단위를 count에 임시 저장
                weight: 0,
                completed: false
            )
        ]
        return WorkoutModel(
            id: id,
            exerciseId: id,
            name: name,
            bodyPart: .unknown,
            muscleGroups: [],
            category: .aerobic,
            status: .inProgress,
            kcalBurned: nil,
            exerciseSets: exerciseSets
        )
    }

    static var plan: [WorkoutModel] {
        [
            makeAnaerobic(id: 1, name: "레그 프레스", sets: 3, count: 12, weight: 60),
            makeAnaerobic(id: 2, name: "벤치 프레스", sets: 3, count: 10, weight: 40),
            makeAerobic(id: 3, name: "트레드밀", minutes: 20)
        ]
    }
}

struct WorkoutTimerPreviewWrapper: View {
    @State var path: [WorkoutRoutineRoute] = []
    
    @StateObject var vm = WorkoutTimerViewModel(
        workoutId: 1,
        initialModels: WorkoutMockFactory.plan,   // ✅ 목 데이터 주입
        startIndex: 0
    )
    
    var body: some View {
        WorkoutTimerView(viewModel: vm, path: $path)
                    .onAppear {
                        // 세트 상태 바로 보고 싶으면:
                        // vm.enterSet()
                    }
    }
}

#Preview {
    WorkoutTimerPreviewWrapper()
}
