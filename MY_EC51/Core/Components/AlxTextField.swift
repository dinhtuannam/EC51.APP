//
//  AlxTextField.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI
import UIKit

// SwiftUI keyboard and text-content modifiers use UIKit platform types.
enum AlxTextFieldSize {
    case small
    case medium
    case large

    var font: Font {
        switch self {
        case .small:
            return .callout
        case .medium:
            return .body
        case .large:
            return .title3
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small:
            return 12
        case .medium:
            return 14
        case .large:
            return 16
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small:
            return 8
        case .medium:
            return 10
        case .large:
            return 12
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

struct AlxTextField: View {
    let title: String?
    let placeholder: String
    @Binding var text: String

    var systemImage: String?
    var helperText: String?
    var errorText: String?
    var size: AlxTextFieldSize
    var isSecure: Bool
    var isDisabled: Bool
    var showsClearButton: Bool
    var keyboardType: UIKeyboardType
    var textContentType: UITextContentType?
    var autocapitalization: TextInputAutocapitalization
    var submitLabel: SubmitLabel
    var onSubmit: () -> Void

    @FocusState private var isFocused: Bool
    @State private var isSecureTextVisible = false

    init(
        _ placeholder: String,
        text: Binding<String>,
        title: String? = nil,
        systemImage: String? = nil,
        helperText: String? = nil,
        errorText: String? = nil,
        size: AlxTextFieldSize = .medium,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        showsClearButton: Bool = true,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .never,
        submitLabel: SubmitLabel = .done,
        onSubmit: @escaping () -> Void = {}
    ) {
        self.placeholder = placeholder
        self._text = text
        self.title = title
        self.systemImage = systemImage
        self.helperText = helperText
        self.errorText = errorText
        self.size = size
        self.isSecure = isSecure
        self.isDisabled = isDisabled
        self.showsClearButton = showsClearButton
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(labelColor)
            }

            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: size.iconSize, weight: .semibold))
                        .foregroundStyle(iconColor)
                }

                inputField

                if showsClearButton && !text.isEmpty && !isSecure && !isDisabled {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: size.iconSize))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(AlxColor.disabled.opacity(0.75))
                }

                if isSecure {
                    Button {
                        isSecureTextVisible.toggle()
                    } label: {
                        Image(systemName: isSecureTextVisible ? "eye.slash" : "eye")
                            .font(.system(size: size.iconSize, weight: .semibold))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(iconColor)
                    .disabled(isDisabled)
                }
            }
            .font(size.font)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(fieldShape.fill(backgroundColor))
            .overlay(fieldShape.stroke(borderColor, lineWidth: isFocused ? 1.5 : 1))
            .opacity(isDisabled ? 0.75 : 1)

            if let message = errorText, !message.isEmpty {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(AlxColor.error)
            } else if let helperText, !helperText.isEmpty {
                Text(helperText)
                    .font(.caption)
                    .foregroundStyle(AlxColor.disabled)
            }
        }
    }

    @ViewBuilder
    private var inputField: some View {
        if isSecure && !isSecureTextVisible {
            SecureField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .textContentType(textContentType)
                .submitLabel(submitLabel)
                .focused($isFocused)
                .onSubmit(onSubmit)
                .disabled(isDisabled)
        } else {
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled()
                .submitLabel(submitLabel)
                .focused($isFocused)
                .onSubmit(onSubmit)
                .disabled(isDisabled)
        }
    }

    private var fieldShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 12)
    }

    private var labelColor: Color {
        hasError ? AlxColor.error : AlxColor.text
    }

    private var iconColor: Color {
        hasError ? AlxColor.error : AlxColor.primary
    }

    private var borderColor: Color {
        if hasError {
            return AlxColor.error
        }

        return isFocused ? AlxColor.primary : AlxColor.border
    }

    private var backgroundColor: Color {
        isDisabled ? AlxColor.disabled.opacity(0.12) : AlxColor.surface
    }

    private var hasError: Bool {
        guard let errorText else { return false }

        return !errorText.isEmpty
    }
}

#Preview {
    VStack(spacing: 8) {
        AlxTextField(
            "Username",
            text: .constant(""),
            title: "Username",
            systemImage: "person"
        )

        AlxTextField(
            "Password",
            text: .constant("123456"),
            title: "Password",
            systemImage: "lock",
            helperText: "Use your EC51 account password.",
            isSecure: true
        )

        AlxTextField(
            "Email",
            text: .constant("wrong-email"),
            title: "Email",
            systemImage: "envelope",
            errorText: "Email is invalid.",
            keyboardType: .emailAddress,
            textContentType: .emailAddress
        )
    }
    .padding()
    .background(AlxColor.background)
}
