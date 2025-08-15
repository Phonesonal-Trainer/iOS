struct MyPageHomeDTO: Decodable {
    let nickname: String?
    let togetherWeeks: Int?
    let targetWeeks: Int?
    let weight: Double?
    let bodyFatRate: Double?
    let muscleMass: DoubleOrString?
    let bmi: Double?
}

enum DoubleOrString: Decodable {
    case double(Double), none
    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let d = try? c.decode(Double.self) { self = .double(d); return }
        if let s = try? c.decode(String.self), let d = Double(s) { self = .double(d); return }
        self = .none
    }
    var value: Double? { if case .double(let d) = self { d } else { nil } }
}
