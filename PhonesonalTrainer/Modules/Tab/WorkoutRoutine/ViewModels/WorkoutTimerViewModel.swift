//
//  WorkoutTimerViewModel.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 8/15/25.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

final class WorkoutTimerViewModel: ObservableObject {
    // MARK: - Input
    let workoutId: Int
    @Published var type: WorkoutType
    private let service: WorkoutTimerService
    
    // 현재 세트의 setId
    private var currentSetId: Int? {
        guard let item = currentItem else { return nil }
        let idx = max(0, min(currentSetIndex - 1, item.setIds.count - 1))
        return item.setIds[idx]
    }

    private var hasStartedOnServer = false
    
    // MARK: - 오늘 플랜 & 인덱스
    @Published var plan: [WorkoutPlanItem] = []         // 오늘 운동들
    @Published private(set) var workoutIndex: Int = 0   // 0-based
    
    // 현재 항목 파생값
    private var currentItem: WorkoutPlanItem? {
        guard (0..<plan.count).contains(workoutIndex) else { return nil }
        return plan[workoutIndex]
    }
    
    // 다음 운동 표시/이동
    var hasNextExercise: Bool { workoutIndex + 1 < plan.count }
    var nextWorkoutName: String {
        guard hasNextExercise else { return "오늘의 마지막 운동" }
        return plan[workoutIndex + 1].name
    }
    
    // 서버/모델에서 주입한다고 가정한 값들(예: FoodService 처럼 WorkoutService로 교체 가능)
    // 여기선 예시로 고정값.
    @Published private(set) var workoutName: String = "레그 프레스"
    @Published private(set) var totalWorkoutsToday: Int = 7
    @Published private(set) var totalSets: Int = 3
    @Published private(set) var targetReps: Int = 15      // 화면 하단 카운트 타깃
    @Published private(set) var currentSetIndex: Int = 1   // 1-based
    @Published private(set) var weight: Int

    // MARK: State Machine
    enum Phase { case preparation, setActive, rest, finished }
    @Published private(set) var phase: Phase = .preparation
    
    
    @Published private(set) var secondsElapsed: Int = 0      // 00:00부터 올라감 (모든 단계 공통)
    @Published private(set) var progress: Double = 0       // 0...1
    @Published private(set) var currentReps: Int = 0
    @Published var soundOn: Bool = true
    @Published private(set) var isPaused: Bool = false
    @Published var showStopPopup: Bool = false
    
    
    // 타이머
    private var ticker: AnyCancellable?
    private var startedAt = Date()
    private var accumulatedElapsed: TimeInterval = 0   // 일시정지까지 누적된 시간
    private var totalSecondsForPhase: Int = 60      // 단계 총 길이(초). 준비/휴식=60, 세트=setDurationSec
    
    // 세트 시간 = 5초 * 동작 수
    private var setDurationSec: Int { 5 * max(targetReps, 1) }
    
    // 메트로놈 (1박자 = setDurationSec/targetReps)
    private var repInterval: Double { max(0.5, Double(setDurationSec) / Double(max(targetReps, 1))) }
    private var nextBeatTime: TimeInterval = 0        // 경과 기준(초)로 비교

    
    // 소리
    private let player = SystemBeep()
    
    // 콜백(상위 라우팅)
    var onRequestNextExercise: (() -> Void)?
    
    // MARK: - Init
    init(workoutId: Int,
        initialModels: [WorkoutModel] = [],
        startIndex: Int = 0,
        service: WorkoutTimerService = .shared)
    {
        self.service = service
        // 1) 로컬에서 먼저 계산 (self 사용 금지)
        let mappedPlan = initialModels.map { WorkoutPlanItem(model: $0) }
        let safeIndex  = min(max(0, startIndex), max(0, mappedPlan.count - 1))
        let current    = mappedPlan.indices.contains(safeIndex) ? mappedPlan[safeIndex] : nil

        // 2) 저장 프로퍼티들을 순서대로 대입 (여기서부터 self 사용 OK)
        self.workoutId = workoutId
        self.type = current?.type ?? .anaerobic

        self.plan = mappedPlan
        self.workoutIndex = safeIndex

        // UI 바인딩용 공개 값들
        self.workoutName = current?.name ?? "운동"
        self.totalWorkoutsToday = mappedPlan.count
        self.totalSets = current?.totalSets ?? 1
        self.targetReps = current?.targetReps ?? 15
        self.currentSetIndex = 1
        self.weight = current?.defaultWeight ?? 0

        // 상태/타이머 기본값 (이미 기본값이 있어도 명시해 두면 안전)
        self.phase = .preparation
        self.secondsElapsed = 0
        self.progress = 0
        self.currentReps = 0
        self.soundOn = true
        self.isPaused = false
        self.showStopPopup = false

        self.startedAt = Date()
        self.accumulatedElapsed = 0
        self.totalSecondsForPhase = 60
        self.nextBeatTime = 0

        // 3) 모든 저장 프로퍼티가 초기화된 "이후"에 메서드 호출
        enterPreparation()
    }
    
    // 외부에서 플랜 교체 시 호출(※ 서버 새 응답 반영)
    func applyNewPlan(_ models: [WorkoutModel], startIndex: Int? = nil) {
        self.plan = models.map { WorkoutPlanItem(model: $0) }
        if let si = startIndex {
            self.workoutIndex = min(max(0, si), max(0, plan.count - 1))
        } else {
            self.workoutIndex = min(self.workoutIndex, max(0, plan.count - 1))
        }
        self.type = currentItem?.type ?? .anaerobic
        applyCurrentItemMeta()
        enterPreparation()
    }
    
    // MARK: - 현재 아이템 메타 반영
    private func applyCurrentItemMeta() {
        let item = currentItem
        workoutName = item?.name ?? "운동"
        totalWorkoutsToday = plan.count
        totalSets = item?.totalSets ?? 1
        targetReps = item?.targetReps ?? 15
        weight = item?.defaultWeight ?? 0
        currentSetIndex = 1
        // 타입도 동기화
        type = item?.type ?? .anaerobic
    }

    
    // MARK: - Phase transitions
    func enterPreparation() {
        // 서버에 "운동 시작"은 최초 1회만
        if !hasStartedOnServer {
            hasStartedOnServer = true
            Task { [weak self] in
                guard let self else { return }
                _ = try? await service.startUserExercise(userExerciseId: self.workoutId)
            }
        }
        configurePhase(total: 60, phase: .preparation)
    }

    func enterSet() {
        configurePhase(total: setDurationSec, phase: .setActive)
        nextBeatTime = repInterval
        currentReps = 0
    }
    
    func enterRest() {
        configurePhase(total: 60, phase: .rest)
    }
    
    private func configurePhase(total: Int, phase: Phase) {
        stopTicking()
        self.phase = phase
        self.totalSecondsForPhase = total
        self.secondsElapsed = 0
        self.progress = 0
        self.accumulatedElapsed = 0
        self.startedAt = Date()
        startTicking()
    }
    
    private func finishOrNext() {
        if phase == .setActive { saveOneSet() }
        if currentSetIndex >= totalSets {
            phase = .finished
            stopTicking()
            // 마지막 세트 저장 & 상태 done
            persistCompletedWorkout()
        } else {
            currentSetIndex += 1
            // 휴식 후 다음 세트 시작 API는 실제로 "다음 세트 들어갈 때" 호출
            enterSet()
        }
    }
    
    // MARK: - Controls
    func togglePause() {
        if isPaused {
            // 재개
            isPaused = false
            startedAt = Date()
            startTicking()
        } else {
            // 일시정지
            isPaused = true
            accumulatedElapsed += Date().timeIntervalSince(startedAt)
            stopTicking()
        }
    }

    func stopTapped() { // 뒤로가기 or 그만하기
        isPaused = true
        accumulatedElapsed += Date().timeIntervalSince(startedAt)
        stopTicking()
        showStopPopup = true
    }

    func confirmStop() {
        // 완료한 세트까지만 저장, 상태는 inProgress 유지
        persistPartialUntilCurrentSetFinished()
    }

    func goToNextExercise() { // 준비/휴식 중에서만 호출
        guard phase == .preparation || phase == .rest else { return }
        stopTicking()
        // 현재 세트까지 저장, 상태 inProgress 유지
        persistPartialUntilCurrentSetFinished()
        // 라우터/상위에 "다음 운동으로" 신호 보냄(실제 구현은 환경/콜백으로)
        guard hasNextExercise else { return }
        workoutIndex += 1
        currentSetIndex = 1                     // 세트 인덱스 초기화
        applyCurrentItemMeta()                  // 이름/세트/무게/타겟 세팅
        enterPreparation()                      // 다음 운동의 준비 타이머로 재시작(60초 카운트업)
        // 상위 라우팅(리스트의 다음 운동 화면으로) — 실제 구현은 상위에서
        onRequestNextExercise?()
    }


    // MARK: - Timer ticking
    private func startTicking() {
        ticker?.cancel()
        ticker = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] t in self?.tick(t) }
    }

    private func stopTicking() {
        ticker?.cancel()
        ticker = nil
    }
    
    private func tick(_ now: Date) {
        let elapsed = accumulatedElapsed + now.timeIntervalSince(startedAt) // 경과(초)
        secondsElapsed = Int(elapsed.rounded(.down))
        progress = min(1, elapsed / Double(totalSecondsForPhase))

        // 세트 중일 때만 ‘빕’/햅틱/카운트
        if phase == .setActive, elapsed >= nextBeatTime {
            nextBeatTime += repInterval
            if soundOn { player.beep() }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            currentReps = min(targetReps, currentReps + 1)
        }

        // 단계 종료
        if secondsElapsed >= totalSecondsForPhase {
            switch phase {
            case .preparation:
                enterSet()

            case .setActive:
                if type == .anaerobic { currentReps = targetReps } // 보정
                saveOneSet()                                       //  여기서 즉시 저장
                enterRest()

            case .rest:
                advanceToNextSetFromRest()                         // 서버 next-set
                if currentSetIndex >= totalSets {
                    phase = .finished
                    stopTicking()
                    persistCompletedWorkout()                      // 전체 완료 API
                } else {
                    currentSetIndex += 1
                    enterSet()
                }

            case .finished:
                break
            }
        }
    }
    
    // MARK: Persistence stubs
    private func saveOneSet() {
        guard let setId = currentSetId else { return }
        Task { [weak self] in
            guard let self else { return }
            _ = try? await service.completeSet(userExerciseId: self.workoutId, setId: setId)
        }
    }
    private func persistPartialUntilCurrentSetFinished() {
        // 지금까지 완료한 세트까지만 저장. workout.status = .inProgress 유지
    }
    private func persistCompletedWorkout() {
        Task { [weak self] in
            guard let self else { return }
            _ = try? await service.completeUserExercise(userExerciseId: self.workoutId)
        }
    }

    // 휴식 ➜ 다음 세트로 넘어갈 때 서버 상태 advance
    // 'rest' 단계가 끝나고 set으로 들어가기 직전에 호출되게 변경
    private func advanceToNextSetFromRest() {
        Task { [weak self] in
            guard let self else { return }
            _ = try? await service.startNextSet(userExerciseId: self.workoutId)
        }
    }
}

// 간단 비프 사운드(시스템 소리)
final class SystemBeep {
    private var player: AVAudioPlayer?
    func beep() {
        // 번들에 짧은 beep.wav 둔다거나, 시스템 사운드 사용
        AudioServicesPlaySystemSound(1104) // 키보드 탭 같은 클릭음
    }
}
