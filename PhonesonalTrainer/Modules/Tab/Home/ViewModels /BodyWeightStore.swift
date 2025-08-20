import Foundation

@MainActor
final class BodyWeightStore: ObservableObject {
    @Published var currentWeight: Double = 0
    @Published var goalWeight: Double   = 60

    private var userId: Int? // ← 나중에 설정

    init(userId: Int? = nil, goalWeight: Double = 60) {
        self.userId = userId
        self.goalWeight = goalWeight
    }

    func configure(userId: Int, goalWeight: Double? = nil) async {
        self.userId = userId
        if let gw = goalWeight { self.goalWeight = gw }
        await refresh()
    }

    func refresh() async {
        guard let uid = userId else { return } // 아직 로그인 전이면 패스
        do {
            let w = try await WeightAPI.fetchCurrent(userId: uid)
            self.currentWeight = w
        } catch {
            print("⚠️ 몸무게 조회 실패:", error.localizedDescription)
            
            // 에러 타입에 따른 처리
            if let nsError = error as NSError? {
                switch nsError.code {
                case 500:
                    print("🔍 몸무게 API 500 에러: 서버 내부 오류")
                case 401, 403:
                    print("🔍 몸무게 API 인증 에러: 토큰 문제")
                default:
                    print("🔍 몸무게 API 기타 에러: \(nsError.code)")
                }
            }
            
            // 기본값 유지 (0으로 설정하지 않음)
            // self.currentWeight = 0  // ← 이렇게 하면 UI에서 0kg으로 표시됨
        }
    }

    func save(_ newWeight: Double) async -> Bool {
        guard let uid = userId else { return false }
        let old = currentWeight
        currentWeight = newWeight
        do {
            try await WeightAPI.update(userId: uid, weight: newWeight)
            return true
        } catch {
            print("⚠️ 몸무게 저장 실패:", error.localizedDescription)
            currentWeight = old
            return false
        }
    }
}
