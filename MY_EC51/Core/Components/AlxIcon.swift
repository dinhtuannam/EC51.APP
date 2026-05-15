//
//  AlxIcon.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

enum AlxIconType: CaseIterable {
    case delete
    case save
    case pin
    case edit
    case share
    case favorite
    case info
    case warning
    case done

    var systemImage: String {
        switch self {
        case .delete:
            return "trash.fill"
        case .save:
            return "archivebox.fill"
        case .pin:
            return "pin.fill"
        case .edit:
            return "pencil"
        case .share:
            return "square.and.arrow.up"
        case .favorite:
            return "heart.fill"
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .done:
            return "checkmark.circle.fill"
        }
    }

    var label: String {
        switch self {
        case .delete:
            return "Delete"
        case .save:
            return "Save"
        case .pin:
            return "Pin"
        case .edit:
            return "Edit"
        case .share:
            return "Share"
        case .favorite:
            return "Favorite"
        case .info:
            return "Info"
        case .warning:
            return "Warning"
        case .done:
            return "Done"
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .delete:
            return LinearGradient(
                colors: [.red, Color(red: 0.8, green: 0.1, blue: 0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .save:
            return LinearGradient(
                colors: [Color(red: 0.18, green: 0.85, blue: 0.38), Color(red: 0.05, green: 0.6, blue: 0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .pin:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.72, blue: 0.1), Color(red: 0.9, green: 0.42, blue: 0.0)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .edit:
            return LinearGradient(
                colors: [Color(red: 0.5, green: 0.4, blue: 1.0), Color(red: 0.28, green: 0.2, blue: 0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .share:
            return LinearGradient(
                colors: [Color(red: 0.1, green: 0.7, blue: 1.0), Color(red: 0.0, green: 0.48, blue: 0.85)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .favorite:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.35, blue: 0.58), Color(red: 0.88, green: 0.1, blue: 0.38)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .info:
            return LinearGradient(
                colors: [Color(red: 0.25, green: 0.65, blue: 1.0), Color(red: 0.08, green: 0.42, blue: 0.92)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .warning:
            return LinearGradient(
                colors: [Color(red: 1.0, green: 0.65, blue: 0.1), Color(red: 0.9, green: 0.35, blue: 0.0)],
                startPoint: .top,
                endPoint: .bottom
            )
        case .done:
            return LinearGradient(
                colors: [Color(red: 0.18, green: 0.8, blue: 0.38), Color(red: 0.05, green: 0.58, blue: 0.22)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

struct AlxIcon: View {
    let type: AlxIconType
    var showText = false
    var width: CGFloat = 72
    var height: CGFloat = 72
    var action: (() -> Void)?

    @State private var isPressed = false

    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Image(systemName: type.systemImage)
                    .font(.system(size: iconSize, weight: .semibold))

                if showText {
                    AlxText(type.label, style: .caption, color: .white)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(type.gradient)

            if isPressed {
                Color.black.opacity(0.15)
                    .allowsHitTesting(false)
            }
        }
        .frame(width: width, height: height)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { value in
                    isPressed = false
                    let location = value.location
                    if location.x >= 0, location.x <= width, location.y >= 0, location.y <= height {
                        action?()
                    }
                }
        )
        .scaleEffect(isPressed ? 0.94 : 1.0)
        .animation(.easeInOut(duration: 0.12), value: isPressed)
    }

    private var minDimension: CGFloat {
        min(width, height)
    }

    private var iconSize: CGFloat {
        showText
            ? max(minDimension * 0.28, 14)
            : max(minDimension * 0.36, 16)
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {
            sectionLabel("Icon only")
            iconRow(showText: false)

            sectionLabel("Icon and text")
            iconRow(showText: true)

            sectionLabel("Swipe card example")
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemBackground))
                    .frame(height: 64)
                    .overlay(alignment: .leading) {
                        AlxText("Swipe left to delete", style: .callout, color: .secondary)
                            .padding(.leading, 16)
                    }
                    .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)

                AlxIcon(type: .delete, showText: true, width: 72, height: 64) {
                    print("Delete tapped")
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 32)
    }
    .background(Color(.systemGroupedBackground))
}

private func sectionLabel(_ text: String) -> some View {
    AlxText(text, style: .footnote, color: .secondary)
        .padding(.horizontal, 20)
}

private func iconRow(showText: Bool) -> some View {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
            ForEach(AlxIconType.allCases, id: \.label) { type in
                AlxIcon(type: type, showText: showText) {
                    print("\(type.label) tapped")
                }
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(.horizontal, 20)
    }
}

