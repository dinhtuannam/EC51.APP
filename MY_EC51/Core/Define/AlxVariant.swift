//
//  AlxButtonVariant.swift
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
                background: .primary,
                foreground: .white,
                border: .primary
            )
        case .warning:
            return Colors(
                background: .warning,
                foreground: .black,
                border: .warning
            )
        case .error:
            return Colors(
                background: .error,
                foreground: .white,
                border: .error
            )
        case .outline:
            return Colors(
                background: .clear,
                foreground: .primary,
                border: .primary
            )
        }
    }
    
    var backgroundColor: Color { colors.background }
    var foregroundColor: Color { colors.foreground }
    var borderColor: Color { colors.border }
}
