import Foundation

struct ReportWeeklyEnvelope: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ReportWeeklyResponse
}

struct ReportWeeklyResponse: Codable {
    let week: Int
    let weekStart: String
    let weekEnd: String
    let feedbackExist: Bool
    let dailyWeight: [String: Double?]
    let changeFromTargetWeight: FuzzyDouble?
    let changeFromInitialWeight: FuzzyDouble?

    enum CodingKeys: String, CodingKey {
        case week
        case weekStart
        case weekEnd
        case feedbackExist
        case dailyWeight
        case changeFromTargetWeight
        case changeFromInitialWeight
    }
}

/// Decodes either a JSON number or a JSON string into Double
struct FuzzyDouble: Codable {
    let value: Double

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let number = try? container.decode(Double.self) {
            value = number
            return
        }
        if let intNumber = try? container.decode(Int.self) {
            value = Double(intNumber)
            return
        }
        if let string = try? container.decode(String.self) {
            value = NumberParsing.extractFirstDouble(from: string) ?? 0
            return
        }
        throw DecodingError.typeMismatch(Double.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type for FuzzyDouble"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}


