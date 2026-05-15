//
//  AlxText.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import SwiftUI

struct AlxText: View {
    private let text: Text
    private let style: AlxTextStyle
    private let color: Color
    private let alignment: TextAlignment
    private let lineLimit: Int?
    private let tracking: CGFloat

    init(
        _ content: String,
        style: AlxTextStyle = .body,
        color: Color = AlxColor.text,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil,
        tracking: CGFloat = 0
    ) {
        AlxFontRegistry.registerFonts()
        self.text = Text(content)
        self.style = style
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
        self.tracking = tracking
    }

    init(
        localized key: LocalizedStringKey,
        style: AlxTextStyle = .body,
        color: Color = AlxColor.text,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil,
        tracking: CGFloat = 0
    ) {
        AlxFontRegistry.registerFonts()
        self.text = Text(key)
        self.style = style
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
        self.tracking = tracking
    }

    var body: some View {
        text
            .font(style.font)
            .tracking(tracking)
            .foregroundStyle(color)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        AlxText("EC51 DEMO", style: .display)
        AlxText("Dashboard", style: .title)
        AlxText("Revenue", style: .title2)
        AlxText("Body text using Be Vietnam Pro.", style: .body)
        AlxText("Caption text", style: .caption, color: AlxColor.disabled)
    }
    .padding()
    .background(AlxColor.appBackground)
}
