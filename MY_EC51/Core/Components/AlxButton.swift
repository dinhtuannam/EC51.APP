//
//  AlxButton.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

struct AlxButton: View {
    let title: String
    var systemImage: String?
    var variant: AlxButtonVariant
    var isLoading: Bool
    var isDisabled: Bool
    let action: () -> Void

    init(
        _ title: String,
        systemImage: String? = nil,
        variant: AlxButtonVariant = .primary,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.variant = variant
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                        .tint(currentForegroundColor)
                } else if let systemImage {
                    Image(systemName: systemImage)
                }

                Text(title)
            }
            .font(.title3)
            .fontWeight(.semibold)
            .kerning(5.0)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isDisabled ? AlxButtonColors.disabled : variant.backgroundColor)
            )
            .foregroundStyle(currentForegroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isDisabled ? AlxButtonColors.disabled : variant.borderColor, lineWidth: 1)
            )
            .opacity(isDisabled ? 0.7 : 1)
        }
        .buttonStyle(.plain)
        .disabled(isInteractionDisabled)
    }

    private var currentForegroundColor: Color {
        isDisabled ? .white : variant.foregroundColor
    }

    private var isInteractionDisabled: Bool {
        isDisabled || isLoading
    }
}

#Preview {
    VStack(spacing: 12) {
        AlxButton("SIGN IN") {}
        AlxButton("LOADING", isLoading: true) {}
        AlxButton("WARNING", variant: .warning) {}
        AlxButton("ERROR", variant: .error) {}
        AlxButton("OUTLINE", variant: .outline) {}
    }
    .padding(.horizontal)
}
