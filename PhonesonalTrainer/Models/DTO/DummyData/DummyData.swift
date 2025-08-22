//
//  DummyData.swift
//  PhonesonalTrainer
//
//  Created by AI Assistant on 8/22/25.
//

import Foundation

// MARK: - 더미 데이터 제공 클래스
struct DummyData {
    
    // MARK: - 홈 화면 더미 데이터
    static let homeMainResult = HomeMainResult(
        main: HomeMainBlock(
            userId: 1,
            targetCalories: 2000,
            todayCalories: 1450,
            targetWeight: 65,
            comment: "오늘도 화이팅! 목표까지 200칼로리 남았어요 💪",
            presentWeek: 3,
            date: "2025-08-22",
            koreanDate: "2025년 8월 22일"
        ),
        exercise: HomeExerciseBlock(
            todayBurnedCalories: 320,
            todayRecommendBurnedCalories: 400,
            anaerobicExerciseTime: 45,
            aerobicExerciseTime: 30,
            exercisePercentage: 80,
            focusedBodyPart: "하체",
            exerciseStatus: "진행중"
        ),
        meal: HomeMealBlock(
            todayRecommendedCalories: 2000,
            todayConsumedCalorie: 1450,
            carb: 180,
            protein: 120,
            fat: 45,
            caloriePercentage: 72,
            calorieStatus: "적정"
        )
    )
    
    // MARK: - 운동 리스트 더미 데이터
    static let userExercises: [UserExercise] = [
        UserExercise(
            userExerciseId: 1,
            recordType: "anaerobic",
            currentSetNumber: 2,
            totalSets: 3,
            exerciseName: "스쿼트",
            date: "2025-08-22",
            state: "진행중",
            exerciseType: "anaerobic",
            actualMinutes: 45,
            exerciseId: 1,
            exerciseSets: [
                ExerciseSet(setId: 1, setNumber: 1, count: 12, weight: 50, completed: true),
                ExerciseSet(setId: 2, setNumber: 2, count: 12, weight: 50, completed: false),
                ExerciseSet(setId: 3, setNumber: 3, count: 12, weight: 50, completed: false)
            ],
            caloriesBurned: 180.0
        ),
        UserExercise(
            userExerciseId: 2,
            recordType: "aerobic",
            currentSetNumber: 1,
            totalSets: 1,
            exerciseName: "러닝",
            date: "2025-08-22",
            state: "완료",
            exerciseType: "aerobic",
            actualMinutes: 30,
            exerciseId: 2,
            exerciseSets: [],
            caloriesBurned: 140.0
        ),
        UserExercise(
            userExerciseId: 3,
            recordType: "anaerobic",
            currentSetNumber: 1,
            totalSets: 3,
            exerciseName: "데드리프트",
            date: "2025-08-22",
            state: "대기중",
            exerciseType: "anaerobic",
            actualMinutes: 0,
            exerciseId: 3,
            exerciseSets: [
                ExerciseSet(setId: 4, setNumber: 1, count: 10, weight: 60, completed: false),
                ExerciseSet(setId: 5, setNumber: 2, count: 10, weight: 60, completed: false),
                ExerciseSet(setId: 6, setNumber: 3, count: 10, weight: 60, completed: false)
            ],
            caloriesBurned: 0.0
        )
    ]
    
    // MARK: - 운동 상세 더미 데이터
    static let exerciseDetail = ExerciseDetail(
        exerciseId: 1,
        name: "스쿼트",
        imageUrl: "https://example.com/squat.jpg",
        youtubeUrl: "https://www.youtube.com/watch?v=example",
        caution: "무릎이 발끝을 넘지 않도록 주의하세요. 허리를 곧게 펴고 시선은 앞을 향하세요.",
        bodyPart: [
            BodyPart(id: 1, nameEn: "Quadriceps", nameKo: "대퇴사두근", bodyCategory: .legs),
            BodyPart(id: 2, nameEn: "Glutes", nameKo: "둔근", bodyCategory: .legs)
        ],
        descriptions: [
            ExerciseDescription(step: 1, main: "발을 어깨 너비로 벌리고 서세요", sub: "발끝은 약간 바깥쪽을 향하게 합니다"),
            ExerciseDescription(step: 2, main: "허리를 곧게 펴고 앉듯이 내려가세요", sub: "무릎이 90도가 될 때까지 내려갑니다"),
            ExerciseDescription(step: 3, main: "천천히 원래 자세로 돌아가세요", sub: "허벅지와 둔근에 힘을 느끼며 올라갑니다")
        ]
    )
    
    // MARK: - 몸무게 더미 데이터
    static let currentWeight: Double = 68.5
    
    // MARK: - 식단 더미 데이터
    static let userMeals: [UserMealItem] = [
        UserMealItem(
            recordId: 1,
            foodId: 1,
            foodName: "현미밥",
            mealTime: "breakfast",
            date: "2025-08-22",
            carb: 45.0,
            protein: 8.0,
            fat: 2.0,
            calorie: 220.0,
            quantity: 1,
            displayServingSize: "1공기",
            defaultServingSize: "1공기",
            imageUrl: "https://example.com/rice.jpg",
            custom: false
        ),
        UserMealItem(
            recordId: 2,
            foodId: 2,
            foodName: "닭가슴살",
            mealTime: "lunch",
            date: "2025-08-22",
            carb: 0.0,
            protein: 25.0,
            fat: 3.0,
            calorie: 120.0,
            quantity: 1,
            displayServingSize: "100g",
            defaultServingSize: "100g",
            imageUrl: "https://example.com/chicken.jpg",
            custom: false
        ),
        UserMealItem(
            recordId: 3,
            foodId: 3,
            foodName: "브로콜리",
            mealTime: "dinner",
            date: "2025-08-22",
            carb: 6.0,
            protein: 4.0,
            fat: 0.5,
            calorie: 45.0,
            quantity: 1,
            displayServingSize: "1컵",
            defaultServingSize: "1컵",
            imageUrl: "https://example.com/broccoli.jpg",
            custom: false
        )
    ]
    
    // MARK: - 식단 플랜 더미 데이터
    static let nutritionSummary = NutritionSummaryResponse(
        date: "2025-08-22",
        summary: NutritionSummaryResponse.Summary(
            breakfast: MealCardSummary(
                carb: 60.0,
                protein: 25.0,
                fat: 15.0,
                calorie: 450.0,
                recordCount: 3,
                imageUrl: "https://example.com/breakfast.jpg",
                status: .withImage
            ),
            lunch: MealCardSummary(
                carb: 75.0,
                protein: 30.0,
                fat: 20.0,
                calorie: 550.0,
                recordCount: 4,
                imageUrl: "https://example.com/lunch.jpg",
                status: .withImage
            ),
            snack: MealCardSummary(
                carb: 25.0,
                protein: 10.0,
                fat: 5.0,
                calorie: 150.0,
                recordCount: 1,
                imageUrl: "https://example.com/snack.jpg",
                status: .noImage
            ),
            dinner: MealCardSummary(
                carb: 40.0,
                protein: 35.0,
                fat: 10.0,
                calorie: 300.0,
                recordCount: 2,
                imageUrl: "https://example.com/dinner.jpg",
                status: .noImage
            )
        ),
        plannedTotalCalorie: 2000,
        actualTotalCalorie: 1450
    )
    
    static let mealItems: [MealModel] = [
        MealModel(
            foodId: 1,
            name: "닭가슴살",
            amount: 150,
            kcal: 250.0,
            imageURL: "https://example.com/chicken.jpg",
            isComplete: true, carb: 0, protein: 42, fat: 3
        ),
        MealModel(
            foodId: 2,
            name: "현미밥",
            amount: 100,
            kcal: 120.0,
            imageURL: "https://example.com/rice.jpg",
            isComplete: true, carb: 25, protein: 2.5, fat: 0.9
        ),
        MealModel(
            foodId: 3,
            name: "브로콜리",
            amount: 80,
            kcal: 45.0,
            imageURL: "https://example.com/broccoli.jpg",
            isComplete: false, carb: 6, protein: 3, fat: 0.5
        )
    ]
    
    static let searchFoods: [MealModel] = [
        MealModel(
            foodId: 1,
            name: "닭가슴살",
            amount: 150,
            kcal: 250.0,
            imageURL: "https://example.com/chicken.jpg",
            isComplete: false
        ),
        MealModel(
            foodId: 2,
            name: "현미밥",
            amount: 100,
            kcal: 120.0,
            imageURL: "https://example.com/rice.jpg",
            isComplete: false
        ),
        MealModel(
            foodId: 3,
            name: "브로콜리",
            amount: 80,
            kcal: 45.0,
            imageURL: "https://example.com/broccoli.jpg",
            isComplete: false
        ),
        MealModel(
            foodId: 4,
            name: "연어",
            amount: 120,
            kcal: 280.0,
            imageURL: "https://example.com/salmon.jpg",
            isComplete: false
        ),
        MealModel(
            foodId: 5,
            name: "퀴노아",
            amount: 90,
            kcal: 110.0,
            imageURL: "https://example.com/quinoa.jpg",
            isComplete: false
        )
    ]
    
    // MARK: - 리포트 더미 데이터
    static let reportData = ReportData(
        week: 3,
        startDate: "2025-08-16",
        endDate: "2025-08-22",
        weightChange: -1.2,
        totalCalories: 12500,
        averageCalories: 1785,
        exerciseDays: 5,
        totalExerciseTime: 240,
        averageExerciseTime: 48,
        weightRecords: [
            WeightRecord(date: "2025-08-16", weight: 69.7),
            WeightRecord(date: "2025-08-17", weight: 69.5),
            WeightRecord(date: "2025-08-18", weight: 69.3),
            WeightRecord(date: "2025-08-19", weight: 69.1),
            WeightRecord(date: "2025-08-20", weight: 68.9),
            WeightRecord(date: "2025-08-21", weight: 68.7),
            WeightRecord(date: "2025-08-22", weight: 68.5)
        ],
        exerciseRecords: [
            ExerciseRecord(date: "2025-08-16", calories: 350, time: 60),
            ExerciseRecord(date: "2025-08-17", calories: 280, time: 45),
            ExerciseRecord(date: "2025-08-18", calories: 420, time: 75),
            ExerciseRecord(date: "2025-08-19", calories: 0, time: 0),
            ExerciseRecord(date: "2025-08-20", calories: 380, time: 65),
            ExerciseRecord(date: "2025-08-21", calories: 320, time: 55),
            ExerciseRecord(date: "2025-08-22", calories: 460, time: 80)
        ],
        mealRecords: [
            MealRecord(date: "2025-08-16", calories: 1850),
            MealRecord(date: "2025-08-17", calories: 1720),
            MealRecord(date: "2025-08-18", calories: 1950),
            MealRecord(date: "2025-08-19", calories: 1680),
            MealRecord(date: "2025-08-20", calories: 1820),
            MealRecord(date: "2025-08-21", calories: 1750),
            MealRecord(date: "2025-08-22", calories: 1450)
        ]
    )
}

// MARK: - 리포트용 더미 데이터 구조체들
struct ReportData {
    let week: Int
    let startDate: String
    let endDate: String
    let weightChange: Double
    let totalCalories: Int
    let averageCalories: Int
    let exerciseDays: Int
    let totalExerciseTime: Int
    let averageExerciseTime: Int
    let weightRecords: [WeightRecord]
    let exerciseRecords: [ExerciseRecord]
    let mealRecords: [MealRecord]
}

struct WeightRecord {
    let date: String
    let weight: Double
}

struct ExerciseRecord {
    let date: String
    let calories: Int
    let time: Int
}

struct MealRecord {
    let date: String
    let calories: Int
}
