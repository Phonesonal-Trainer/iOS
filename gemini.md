# Gemini Project Overview: Phonesonal-Trainer

## 1. Project Summary

**Phonesonal-Trainer** is an iOS mobile application that acts as a virtual personal trainer. It provides users with personalized weekly meal plans and workout routines based on their initial diagnosis and ongoing feedback. The app focuses on easy progress tracking and continuous adaptation to user input.

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Core Technologies:** Combine for reactive programming, Alamofire/Moya for networking.

## 2. Key Features

The application is built around the following core user flows:

- **Onboarding:** Collects user data (goals, physical metrics) to create an initial profile.
- **Meal Planning:** Generates and displays weekly meal plans. Allows users to track their meals.
- **Workout Routines:** Provides weekly, customized workout routines. Includes a timer that auto-records workout sessions.
- **Reporting:** Shows weekly reports on user progress and goal achievement.
- **Feedback Loop:** Allows users to provide feedback on the weekly plans, which influences the next week's recommendations.
- **Authentication:** Manages user login and sessions.

## 3. Codebase Structure

The project follows a feature-based modular architecture, primarily organized within the `PhonesonalTrainer/` directory.

- **/PhonesonalTrainer/Modules/**: This is the heart of the application, where each feature or screen is organized into its own module.
    - Each module (e.g., `Home`, `MealPlan`, `WorkoutRoutine`, `Report`) contains `Views` and `ViewModels` subdirectories, strictly following the **MVVM** pattern.
    - The main app navigation is handled by `Tab/MainTabView.swift`.

- **/PhonesonalTrainer/Models/**: Contains all data structures.
    - `Domain/`: Core business logic models (e.g., `MealModel`, `WorkoutDetailModel`).
    - `DTO/`: Data Transfer Objects for API requests and responses (e.g., `SignupRequest`, `FoodPlanResponse`). This indicates a clear separation between network and domain layers.
    - `OnBoarding/`: Models specific to the user onboarding flow.

- **/PhonesonalTrainer/Common/**: Contains reusable code shared across different modules.
    - `Components/`: Shared SwiftUI views (e.g., `FoodCard`, `WorkoutCard`, `PageIndicator`).
    - `Enum/`: App-wide enumerations like `AppRoute`, `MealType`, `WorkoutType`.
    - `Protocol/`: Shared service protocols, like `FoodServiceType`.

- **/PhonesonalTrainer/DesignSystem/**: Manages the app's visual identity.
    - Contains extensions for `Colors` and `Typography`, ensuring a consistent look and feel.

- **/PhonesonalTrainer/Resource/**: Holds all static assets.
    - `Assets.xcassets/`: Images, icons, and the app icon.
    - `Colors.xcassets/`: Custom color sets.
    - `Font/`: Custom fonts used in the app (`Pretendard`).

## 4. Development Conventions

- **Architecture**: Strictly MVVM. Views should be lightweight and delegate all logic to ViewModels.
- **Networking**: Networking is abstracted via services. Use DTOs for all API communication.
- **Dependencies**: Managed via Swift Package Manager (as indicated by the `SPM` badge in the README). Key libraries include `Alamofire`, `Moya`, and `Kingfisher`.
- **Git Conventions**: The `README.md` specifies detailed branch, PR, and commit message conventions. Please adhere to these (e.g., `feat/xx` for branches, `[Feat]` for PR/commit titles).
