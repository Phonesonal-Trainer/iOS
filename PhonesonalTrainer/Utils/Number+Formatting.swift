import Foundation

enum NumberParsing {
    static func extractFirstDouble(from string: String) -> Double? {
        let pattern = "[-+]?\\d+(?:\\.\\d+)?"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(location: 0, length: (string as NSString).length)
        if let match = regex.firstMatch(in: string, range: range) {
            let matchRange = match.range
            let matched = (string as NSString).substring(with: matchRange)
            return Double(matched)
        }
        return nil
    }

    static func formatSignedKg(_ value: Double?) -> String {
        guard let value = value else { return "–" }
        let sign = value >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", value))kg"
    }
}


