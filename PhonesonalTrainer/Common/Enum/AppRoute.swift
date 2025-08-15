//
//  AppRoute.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/1/25.
//

// 각 탭마다 필요한 route enum
import Foundation

/// Home(마이페이지로 가는거 + 마이페이지 내부에서) 화면에서 일어나는 navigation 흐름
enum HomeRoute: Hashable {
    
}
/// WorkoutRoutine 화면에서 일어나는 navigation 흐름
enum WorkoutRoutineRoute: Hashable {
    case workoutSearch
    case manualAdd
}
/// MealPlan 화면에서 일어나는 navigation 흐름
enum MealPlanRoute: Hashable {
    case mealRecord
    case foodSearch
    case manualAdd
}
/// Report 화면에서 일어나는 navigation 흐름
enum ReportRoute: Hashable {
    case feedback
}
