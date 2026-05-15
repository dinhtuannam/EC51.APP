//
//  AlxFont.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import CoreText
import Foundation
import SwiftUI

enum AlxFontWeight {
    case regular
    case medium
    case semibold
    case bold

    var fontName: String {
        switch self {
        case .regular:
            return "BeVietnamPro-Regular"
        case .medium:
            return "BeVietnamPro-Medium"
        case .semibold:
            return "BeVietnamPro-SemiBold"
        case .bold:
            return "BeVietnamPro-Bold"
        }
    }
}

enum AlxFontRegistry {
    private static var isRegistered = false
    private static let fontFiles = [
        "BeVietnamPro-Regular",
        "BeVietnamPro-Medium",
        "BeVietnamPro-SemiBold",
        "BeVietnamPro-Bold"
    ]

    static func registerFonts() {
        guard !isRegistered else {
            return
        }

        fontFiles.forEach(registerFont)
        isRegistered = true
    }

    private static func registerFont(named fileName: String) {
        guard let fontURL = Bundle.main.url(forResource: fileName, withExtension: "ttf") else {
            return
        }

        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
    }
}

enum AlxTextStyle {
    case display
    case title
    case title2
    case headline
    case subheadline
    case body
    case callout
    case footnote
    case caption
    case buttonSmall
    case button
    case buttonLarge

    var size: CGFloat {
        switch self {
        case .display:
            return 34
        case .title:
            return 28
        case .title2:
            return 22
        case .headline:
            return 17
        case .subheadline:
            return 15
        case .body:
            return 16
        case .callout:
            return 15
        case .footnote:
            return 13
        case .caption:
            return 12
        case .button:
            return 16
        case .buttonSmall:
            return 15
        case .buttonLarge:
            return 20
        }
    }

    var weight: AlxFontWeight {
        switch self {
        case .display, .title, .title2:
            return .bold
        case .headline, .buttonSmall, .button, .buttonLarge:
            return .semibold
        case .subheadline, .callout:
            return .medium
        case .body, .footnote, .caption:
            return .regular
        }
    }

    var relativeTo: Font.TextStyle {
        switch self {
        case .display:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .body:
            return .body
        case .callout:
            return .callout
        case .footnote:
            return .footnote
        case .caption:
            return .caption
        case .button:
            return .headline
        case .buttonSmall:
            return .callout
        case .buttonLarge:
            return .title3
        }
    }

    var font: Font {
        .custom(weight.fontName, size: size, relativeTo: relativeTo)
    }
}
