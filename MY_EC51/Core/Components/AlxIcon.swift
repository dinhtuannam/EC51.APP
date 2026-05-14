//
//  AlxIcon.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

// MARK: - AlxIconType
enum AlxIconType: CaseIterable {
    case delete, save, pin, edit, share, favorite, info, warning, done

    var systemImage: String {
        switch self {
        case .delete:   return "trash.fill"
        case .save:     return "archivebox.fill"
        case .pin:      return "pin.fill"
        case .edit:     return "pencil"
        case .share:    return "square.and.arrow.up"
        case .favorite: return "heart.fill"
        case .info:     return "info.circle.fill"
        case .warning:  return "exclamationmark.triangle.fill"
        case .done:     return "checkmark.circle.fill"
        }
    }

    var label: String {
        switch self {
        case .delete:   return "Delete"
        case .save:     return "Save"
        case .pin:      return "Pin"
        case .edit:     return "Edit"
        case .share:    return "Share"
        case .favorite: return "Favorite"
        case .info:     return "Info"
        case .warning:  return "Warning"
        case .done:     return "Done"
        }
    }

    // Dùng .background(gradient) — gradient không bị tint override
    var gradient: LinearGradient {
        switch self {
        case .delete:
            return LinearGradient(colors: [.red, Color(red: 0.8, green: 0.1, blue: 0.1)],
                                  startPoint: .top, endPoint: .bottom)
        case .save:
            return LinearGradient(colors: [Color(red: 0.18, green: 0.85, blue: 0.38),
                                           Color(red: 0.05, green: 0.6,  blue: 0.2)],
                                  startPoint: .top, endPoint: .bottom)
        case .pin:
            return LinearGradient(colors: [Color(red: 1.0,  green: 0.72, blue: 0.1),
                                           Color(red: 0.9,  green: 0.42, blue: 0.0)],
                                  startPoint: .top, endPoint: .bottom)
        case .edit:
            return LinearGradient(colors: [Color(red: 0.5,  green: 0.4,  blue: 1.0),
                                           Color(red: 0.28, green: 0.2,  blue: 0.8)],
                                  startPoint: .top, endPoint: .bottom)
        case .share:
            return LinearGradient(colors: [Color(red: 0.1,  green: 0.7,  blue: 1.0),
                                           Color(red: 0.0,  green: 0.48, blue: 0.85)],
                                  startPoint: .top, endPoint: .bottom)
        case .favorite:
            return LinearGradient(colors: [Color(red: 1.0,  green: 0.35, blue: 0.58),
                                           Color(red: 0.88, green: 0.1,  blue: 0.38)],
                                  startPoint: .top, endPoint: .bottom)
        case .info:
            return LinearGradient(colors: [Color(red: 0.25, green: 0.65, blue: 1.0),
                                           Color(red: 0.08, green: 0.42, blue: 0.92)],
                                  startPoint: .top, endPoint: .bottom)
        case .warning:
            return LinearGradient(colors: [Color(red: 1.0,  green: 0.65, blue: 0.1),
                                           Color(red: 0.9,  green: 0.35, blue: 0.0)],
                                  startPoint: .top, endPoint: .bottom)
        case .done:
            return LinearGradient(colors: [Color(red: 0.18, green: 0.8,  blue: 0.38),
                                           Color(red: 0.05, green: 0.58, blue: 0.22)],
                                  startPoint: .top, endPoint: .bottom)
        }
    }
}

// MARK: - AlxIcon
/// Cách tiếp cận mới: gradient được vẽ bằng Rectangle nằm ngoài Button label.
/// Button chỉ đảm nhiệm vùng tap (contentShape) và hiệu ứng nhấn.
/// Tránh hoàn toàn việc tint/accentColor của Button override màu gradient.
struct AlxIcon: View {

    let type: AlxIconType
    var showText: Bool   = false
    var width: CGFloat   = 72
    var height: CGFloat  = 72
    var action: (() -> Void)?

    // Trạng thái nhấn để tự làm hiệu ứng press
    @State private var isPressed = false

    var body: some View {
        ZStack {
            // Content: foregroundStyle(.white) + .background(gradient)
            // Đây là pattern hoạt động — gradient trong .background() không bị tint override
            VStack(spacing: 5) {
                Image(systemName: type.systemImage)
                    .font(.system(size: iconSize, weight: .semibold))

                if showText {
                    Text(type.label)
                        .font(.system(size: labelSize, weight: .semibold))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(type.gradient)

            // Press dimming overlay
            if isPressed {
                Color.black.opacity(0.15)
                    .allowsHitTesting(false)
            }
        }
        .frame(width: width, height: height)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in if !isPressed { isPressed = true } }
                .onEnded { value in
                    isPressed = false
                    let loc = value.location
                    if loc.x >= 0, loc.x <= width, loc.y >= 0, loc.y <= height {
                        action?()
                    }
                }
        )
        .scaleEffect(isPressed ? 0.94 : 1.0)
        .animation(.easeInOut(duration: 0.12), value: isPressed)
    }

    // MARK: Scaling helpers
    private var minDimension: CGFloat { min(width, height) }

    private var iconSize: CGFloat {
        showText
            ? max(minDimension * 0.28, 14)
            : max(minDimension * 0.36, 16)
    }

    private var labelSize: CGFloat {
        max(minDimension * 0.16, 10)
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {

            // Icon only
            sectionLabel("Icon only (default)")
            iconRow(showText: false)

            // Icon + Text
            sectionLabel("Icon + Text")
            iconRow(showText: true)

            // Custom sizes
            sectionLabel("Custom sizes")
            HStack(spacing: 16) {
                AlxIcon(type: .delete, showText: true, width: 56,  height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                AlxIcon(type: .save,   showText: true, width: 80,  height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                AlxIcon(type: .pin,    showText: true, width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                AlxIcon(type: .done,   showText: true, width: 72,  height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(.horizontal, 20)

            // Dùng trong swipe card
            sectionLabel("Swipe card example")
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemBackground))
                    .frame(height: 64)
                    .overlay(alignment: .leading) {
                        Text("Vuốt trái để xoá →")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
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

// MARK: - Preview helpers (file-scope)
private func sectionLabel(_ text: String) -> some View {
    Text(text)
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(.secondary)
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
