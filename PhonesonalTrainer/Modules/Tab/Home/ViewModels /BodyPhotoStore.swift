//
//  BodyPicStore.swift
//  PhonesonalTrainer
//
//  Created by 조상은 on 8/15/25.
//

// BodyPhotoStore.swift
import SwiftUI
import UIKit
import Foundation

struct BodyPhotoEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let fileName: String          // ex) body_20250815_153012_xxx.jpg
    let filePath: String          // ex) Documents/bodyphoto/...
    let date: String              // "yyyy-MM-dd" (오늘 비교용)
}

@MainActor
final class BodyPhotoStore: ObservableObject {
    @Published private(set) var entries: [BodyPhotoEntry] = []

    private let folderName = "bodyphoto"
    private let manifestKey = "bodyPhotoManifest" // UserDefaults JSON
    private let apiBase = "https://<YOUR_BASE_URL>" // ✅ 실제 베이스 URL로 교체

    init() {
        loadManifest()
    }

    // MARK: - Public API
    var todayKey: String { Self.dayString(Date()) }
    var hasTodayPhoto: Bool { entries.contains { $0.date == todayKey } }

    func todayImage() -> UIImage? {
        guard let e = entries.first(where: { $0.date == todayKey }) else { return nil }
        let url = Self.folderURL(folderName: folderName).appendingPathComponent(e.fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    /// 저장: 파일은 누적, 매니페스트에 오늘 항목 추가(중복이면 교체)
    func saveToday(image: UIImage) {
        do {
            try FileManager.default.createDirectory(
                at: Self.folderURL(folderName: folderName),
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            print("❌ createDirectory error:", error)
        }

        let stamp = Self.timestamp(Date()) // "yyyyMMdd_HHmmss"
        let name = "body_\(stamp)_\(UUID().uuidString).jpg"
        let url = Self.folderURL(folderName: folderName).appendingPathComponent(name)

        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        do {
            try data.write(to: url, options: .atomic)
            let entry = BodyPhotoEntry(
                id: UUID(),
                fileName: name,
                filePath: Self.relativePath(for: url),
                date: todayKey
            )
            if let idx = entries.firstIndex(where: { $0.date == todayKey }) {
                entries[idx] = entry
            } else {
                entries.insert(entry, at: 0)
            }
            persistManifest()
        } catch {
            print("❌ save error:", error)
        }
    }

    /// 홈에서 "오늘 사진"만 삭제
    func deleteToday() {
        guard let idx = entries.firstIndex(where: { $0.date == todayKey }) else { return }
        let name = entries[idx].fileName
        let url = Self.folderURL(folderName: folderName).appendingPathComponent(name)
        try? FileManager.default.removeItem(at: url) // 파일 제거(선택)
        entries.remove(at: idx)
        persistManifest()
    }

    // 리포트 화면용 전체 목록(썸네일/원본 로딩 등에서 활용)
    func allEntries() -> [BodyPhotoEntry] { entries }

    // MARK: - 서버 동기화 (GET /home/{userId}/main/get-bodyphoto)
    /// 서버에서 오늘자 눈바디를 받아와서 로컬 "오늘 사진"으로 저장
    func syncTodayFromServer(userId: Int) async {
        guard userId != 0 else { return }
        do {
            guard let fileURL = try await fetchBodyPhotoURL(userId: userId) else { return }

            // 보호 경로 판단(필요 없으면 항상 false)
            if needsAuth(for: fileURL) {
                var req = URLRequest(url: fileURL)
                req.httpMethod = "GET"
                req.addAuthToken() // 🔑 Authorization: Bearer <token>
                let (data, resp) = try await URLSession.shared.data(for: req)
                guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return }
                if let img = UIImage(data: data) { saveToday(image: img) }
            } else {
                let (data, _) = try await URLSession.shared.data(from: fileURL)
                if let img = UIImage(data: data) { saveToday(image: img) }
            }
        } catch {
            print("❌ syncTodayFromServer error:", error)
        }
    }

    /// 서버에서 filePath를 받아 `URL`로 변환
    private func fetchBodyPhotoURL(userId: Int) async throws -> URL? {
        guard let url = URL(string: "\(apiBase)/home/\(userId)/main/get-bodyphoto") else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addAuthToken() // 🔑 필요 시

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            print("❌ bodyphoto status:", (resp as? HTTPURLResponse)?.statusCode ?? -1)
            return nil
        }

        struct BodyPhotoResultDTO: Decodable {
            let userId: Int
            let fileName: String
            let filePath: String
        }
        struct APIResponse<T: Decodable>: Decodable {
            let isSuccess: Bool
            let code: String?
            let message: String?
            let result: T?
        }

        let decoded = try JSONDecoder().decode(APIResponse<BodyPhotoResultDTO>.self, from: data)
        guard decoded.isSuccess, let r = decoded.result else {
            print("❌ server msg:", decoded.message ?? "-")
            return nil
        }

        if let abs = URL(string: r.filePath), abs.scheme != nil {
            return abs
        } else {
            return URL(string: apiBase + r.filePath)
        }
    }

    /// 파일링크가 보호 경로인지 네 규칙에 맞게 판단 (필요 없으면 항상 false)
    private func needsAuth(for url: URL) -> Bool {
        // 예: API 도메인과 같으면 보호 경로라고 가정
        // return url.host == URL(string: apiBase)?.host
        return false
    }

    // MARK: - Manifest
    private func loadManifest() {
        guard let data = UserDefaults.standard.data(forKey: manifestKey) else { return }
        if let decoded = try? JSONDecoder().decode([BodyPhotoEntry].self, from: data) {
            self.entries = decoded
        }
    }
    private func persistManifest() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: manifestKey)
        }
    }

    // MARK: - Paths / Dates
    private static func folderURL(folderName: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(folderName, isDirectory: true)
    }
    private static func relativePath(for url: URL) -> String {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let base = docs.path.hasSuffix("/") ? docs.path : docs.path + "/"
        return url.path.replacingOccurrences(of: base, with: "")
    }
    private static func dayString(_ d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: d)
    }
    private static func timestamp(_ d: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "yyyyMMdd_HHmmss"
        return f.string(from: d)
    }
}
