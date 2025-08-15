// UserProfileViewModel.swift
import Foundation
import Combine

@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published var name: String = " "
       @Published var heightCm: Int = 0
       @Published var age: Int = 0
       @Published var genderKo: String = "-"   // "남성"/"여성"

       @Published var isLoading = false
       @Published var lastError: String?

    // 닉네임 변경 (이전 그대로)
    func updateName(_ newName: String) async {
        isLoading = true; lastError = nil
        do {
            let _: APIResponse<String> = try await APIClient.shared.patch(
                path: "/mypage/nickname",
                queryItems: [URLQueryItem(name: "nickname", value: newName)]
            )
            self.name = newName
        } catch {
            self.lastError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    // ✅ 신장 변경
    func updateHeight(_ newHeight: Int) async {
        isLoading = true; lastError = nil
        do {
            let _: APIResponse<String> = try await APIClient.shared.patch(
                path: "/mypage/height",
                queryItems: [URLQueryItem(name: "height", value: String(newHeight))]
            )
            self.heightCm = newHeight
        } catch {
            self.lastError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
    
    //프로필 조회
    func fetchProfile() async {
           isLoading = true; lastError = nil
           do {
               let res: APIResponse<ProfileDTO> = try await APIClient.shared.get(path: "/mypage/profile")
               guard let p = res.result else {
                   throw APIError.server("프로필 응답이 비어 있습니다")
               }
               self.name = p.nickname
               self.age = p.age
               self.heightCm = p.height
               self.genderKo = (p.gender == .MALE) ? "남성" : "여성"
           } catch {
               self.lastError = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
           }
           isLoading = false
       }
    
}
