//
//  AlxButtonVariant.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

enum AlxButtonColors {
    static let primary = Color(red: 13.0 / 255.0, green: 110.0 / 255.0, blue: 253.0 / 255.0)
    static let warning = Color(red: 255.0 / 255.0, green: 193.0 / 255.0, blue: 7.0 / 255.0)
    static let error = Color(red: 220.0 / 255.0, green: 53.0 / 255.0, blue: 69.0 / 255.0)
    static let outline = Color(red: 13.0 / 255.0, green: 110.0 / 255.0, blue: 253.0 / 255.0)
    static let disabled = Color(red: 108.0 / 255.0, green: 117.0 / 255.0, blue: 125.0 / 255.0)
}

enum AlxButtonVariant {
    case primary
    case warning
    case error
    case outline

    var backgroundColor: Color {
        switch self {
        case .primary:
            return AlxButtonColors.primary
        case .warning:
            return AlxButtonColors.warning
        case .error:
            return AlxButtonColors.error
        case .outline:
            return .clear
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary, .error:
            return .white
        case .warning:
            return .black
        case .outline:
            return AlxButtonColors.outline
        }
    }

    var borderColor: Color {
        switch self {
        case .primary:
            return AlxButtonColors.primary
        case .warning:
            return AlxButtonColors.warning
        case .error:
            return AlxButtonColors.error
        case .outline:
            return AlxButtonColors.outline
        }
    }
}
