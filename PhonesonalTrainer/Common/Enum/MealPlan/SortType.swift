//
//  SortType.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/24/25.
//

import Foundation

/// 앱 내부 정렬 타입 (세그먼트/필터용)
enum SortType: String, CaseIterable, Identifiable {
    case frequency
    case favorite
    
    var id: Self { self }

    // 서버 API 호출 시 이 상태값을 스웨거에서 요구하는 문자열 값(popular 또는 favorite)으로 변환하는 기능
    /// 서버 쿼리 파라미터 값 매핑
    /// - 스웨거 기준: popularity 정렬은 "popular", 즐겨찾기 정렬은 "favorite"
    var queryValue: String {
        switch self {
        case .frequency: return "popular"
        case .favorite:  return "favorite"
        }
    }

    /// 서버에서 내려온 정렬 문자열을 앱 내부 타입으로 역매핑 (옵셔널)
    /// - 예: "popular" -> .frequency, "favorite" -> .favorite
    init?(serverValue: String?) {
        switch (serverValue ?? "").lowercased() {
        case "popular":  self = .frequency
        case "favorite": self = .favorite
        default:         return nil
        }
    }

    /// 네트워킹에 바로 쓸 수 있는 헬퍼
    /// - 예: comps.queryItems?.append(sort.asQueryItem())
    func asQueryItem(name: String = "sort") -> URLQueryItem {
        URLQueryItem(name: name, value: queryValue)
    }
}

// 서버 API 호출 시 이 상태값을 스웨거에서 요구하는 문자열 값(popular 또는 favorite)으로 변환하는 기능
