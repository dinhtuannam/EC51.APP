//
//  AlxVariant.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

enum AlxVariant {
    case primary
    case warning
    case error
    case outline
    
    struct Colors {
        let background: Color
        let foreground: Color
        let border: Color
    }
    
    var colors: Colors {
        switch self {
        case .primary:
            return Colors(
                background: AlxColor.primary,
                foreground: .white,
                border: AlxColor.primary
            )
        case .warning:
            return Colors(
                background: AlxColor.warning,
                foreground: .white,
                border: AlxColor.warning
            )
        case .error:
            return Colors(
                background: AlxColor.error,
                foreground: .white,
                border: AlxColor.error
            )
        case .outline:
            return Colors(
                background: .clear,
                foreground: AlxColor.primary,
                border: AlxColor.primary
            )
        }
    }
    
    var backgroundColor: Color { colors.background }
    var foregroundColor: Color { colors.foreground }
    var borderColor: Color { colors.border }
}
