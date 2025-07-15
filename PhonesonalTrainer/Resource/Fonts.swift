//
//  Fonts.swift
//  PhonesonalTrainer
//
//  Created by Sua Cho on 7/15/25.
//

import Foundation
import SwiftUI

extension Font {
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static var PretendardSemiBold22: Font {
        return .pretend(type: .semibold, size: 22)
    }
    
    static var PretendardSemiBold20: Font {
        return .pretend(type: .semibold, size: 20)
    }
    
    static var PretendardSemiBold18: Font {
        return .pretend(type: .semibold, size: 18)
    }
    
    static var PretendardSemiBold14: Font {
        return .pretend(type: .semibold, size: 14)
    }
    
    static var PretendardSemiBold12: Font {
        return .pretend(type: .semibold, size: 12)
    }
    
    static var PretendardSemiBold10: Font {
        return .pretend(type: .medium, size: 10)
    }
    
    static var PretendardSemiBold26: Font {
        return .pretend(type: .medium, size: 26)
    }
    
    static var PretendardMedium22: Font {
        return .pretend(type: .medium, size: 22)
    }
    
    static var PretendardMedium20: Font {
        return .pretend(type: .medium, size: 20)
    }
    
    static var PretendardMedium18: Font {
        return .pretend(type: .medium, size: 18)
    }
    
    static var PretendardMedium14: Font {
        return .pretend(type: .medium, size: 14)
    }
    
    static var PretendardMedium12: Font {
        return .pretend(type: .medium, size: 12)
    }
    
    static var PretendardMedium10: Font {
        return .pretend(type: .medium, size: 10)
    }
    
    static var PretendardRegular22: Font {
        return .pretend(type: .regular, size: 22)
    }
    
    static var PretendardRegular20: Font {
        return .pretend(type: .regular, size: 20)
    }
    
    static var PretendardRegular18: Font {
        return .pretend(type: .regular, size: 18)
    }
    
    static var PretendardRegular14: Font {
        return .pretend(type: .regular, size: 14)
    }
    
    static var PretendardRegular12: Font {
        return .pretend(type: .regular, size: 12)
    }
    
    static var PretendardRegular10: Font {
        return .pretend(type: .regular, size: 10)
    }
    
    static var PretendardRegular26: Font {
        return .pretend(type: .regular, size: 26)
    }
}


