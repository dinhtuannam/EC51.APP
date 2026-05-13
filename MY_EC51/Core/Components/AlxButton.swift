//
//  AlxButton.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

enum AlxButtonSize {
    case small
    case medium
    case large

    var font: Font {
        switch self {
        case .small:
            return .subheadline
        case .medium:
            return .headline
        case .large:
            return .title3
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small:
            return 12
        case .medium:
            return 16
        case .large:
            return 20
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small:
            return 8
        case .medium:
            return 12
        case .large:
            return 14
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small:
            return 14
        case .medium:
            return 16
        case .large:
            return 18
        }
    }
}

enum AlxButtonIconPosition {
    case leading
    case trailing
}

struct AlxButton<Content: View>: View {
    var variant: AlxVariant
    var size: AlxButtonSize
    var isLoading: Bool
    var isDisabled: Bool
    var isFullWidth: Bool
    var cornerRadius: CGFloat
    var action: () -> Void
    @ViewBuilder var content: () -> Content

    init(
        variant: AlxVariant = .primary,
        size: AlxButtonSize = .large,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        isFullWidth: Bool = true,
        cornerRadius: CGFloat = 12,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.isFullWidth = isFullWidth
        self.cornerRadius = cornerRadius
        self.action = action
        self.content = content
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                        .tint(foregroundColor)
                }

                content()
            }
            .font(size.font)
            .fontWeight(.semibold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(backgroundShape.fill(backgroundColor))
            .foregroundStyle(foregroundColor)
            .overlay(backgroundShape.stroke(borderColor, lineWidth: 1))
            .opacity(isDisabled ? 0.7 : 1)
        }
        .buttonStyle(.plain)
        .disabled(isInteractionDisabled)
    }

    private var backgroundShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius)
    }

    private var backgroundColor: Color {
        isDisabled ? AlxColor.disabled : variant.backgroundColor
    }

    private var foregroundColor: Color {
        isDisabled ? .white : variant.foregroundColor
    }

    private var borderColor: Color {
        isDisabled ? AlxColor.disabled : variant.borderColor
    }

    private var isInteractionDisabled: Bool {
        isDisabled || isLoading
    }
}

extension AlxButton where Content == AlxButtonTitleContent {
    init(
        _ title: String,
        systemImage: String? = nil,
        iconPosition: AlxButtonIconPosition = .leading,
        loadingTitle: String? = nil,
        variant: AlxVariant = .primary,
        size: AlxButtonSize = .large,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        isFullWidth: Bool = true,
        cornerRadius: CGFloat = 12,
        action: @escaping () -> Void
    ) {
        self.init(
            variant: variant,
            size: size,
            isLoading: isLoading,
            isDisabled: isDisabled,
            isFullWidth: isFullWidth,
            cornerRadius: cornerRadius,
            action: action
        ) {
            AlxButtonTitleContent(
                title: isLoading ? loadingTitle ?? title : title,
                systemImage: isLoading ? nil : systemImage,
                iconPosition: iconPosition,
                iconSize: size.iconSize
            )
        }
    }
}

struct AlxButtonTitleContent: View {
    let title: String
    let systemImage: String?
    let iconPosition: AlxButtonIconPosition
    let iconSize: CGFloat

    var body: some View {
        HStack(spacing: 8) {
            if iconPosition == .leading {
                icon
                titleText
            } else {
                titleText
                icon
            }
        }
    }

    private var titleText: some View {
        Text(title)
            .kerning(5.0)
    }

    @ViewBuilder
    private var icon: some View {
        if let systemImage {
            Image(systemName: systemImage)
                .font(.system(size: iconSize, weight: .semibold))
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        AlxButton("SIGN IN") {}
        AlxButton("SIGN IN", loadingTitle: "LOADING", isLoading: true) {}
        AlxButton("WARNING", variant: .warning) {}
        AlxButton("ERROR", systemImage: "trash", variant: .error) {}
        AlxButton("OUTLINE", systemImage: "arrow.right", iconPosition: .trailing, variant: .outline) {}
        AlxButton(variant: .outline, isFullWidth: false) {

        } content: {
            HStack(spacing: 6) {
                Image(systemName: "plus")
                Text("CUSTOM")
            }
        }
    }
    .padding(.horizontal)
}
