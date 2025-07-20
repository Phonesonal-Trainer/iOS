//
//  MealType.swift
//  PhonesonalTrainer
//
//  Created by 강리현 on 7/18/25.
//

import Foundation
import SwiftUI

/// 주문 화면에서 사용할 세그먼트 항목을 정의한 열거형.
/// - 'breakfast' : 아침
/// - 'lunch' : 점심
/// - 'dinner' : 저녁
/// - 'snack' : 간식
///
/// `SegmentAttr` 프로토콜을 채택하여 각 항목의 제목(`segmentTitle`)과 스타일(`segmentFont`)을 세그먼트 UI에서 통일되게 사용.
enum MealType: String, SegmentAttr {
    case breakfast = "아침"
    case lunch = "점심"
    case dinner = "저녁"
    case snack = "간식"
    
    var segmentTitle: String {
        self.rawValue
    }
    
    var segmentFont: Font {
        return .PretendardMedium18
    }
}
