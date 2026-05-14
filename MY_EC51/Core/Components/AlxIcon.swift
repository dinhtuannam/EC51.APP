//
//  AlxIcon.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

// MARK: - AlxIconType
enum AlxIconType {
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

    var gradient: LinearGradient {
        switch self {

        case .delete:
            // Strong vivid red
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.18, blue: 0.18),
                    Color(red: 0.78, green: 0.0, blue: 0.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .save:
            // Bright fresh green
            return LinearGradient(
                colors: [
                    Color(red: 0.22, green: 1.0, blue: 0.45),
                    Color(red: 0.0, green: 0.78, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .pin:
            // Attention / highlight amber
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.72, blue: 0.22),
                    Color(red: 0.95, green: 0.45, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .edit:
            // Creative / active indigo
            return LinearGradient(
                colors: [
                    Color(red: 0.52, green: 0.42, blue: 1.0),
                    Color(red: 0.32, green: 0.24, blue: 0.82)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .share:
            // Connected / communication cyan
            return LinearGradient(
                colors: [
                    Color(red: 0.22, green: 0.82, blue: 1.0),
                    Color(red: 0.0, green: 0.58, blue: 0.88)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .favorite:
            // Warm emotional pink
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.42, blue: 0.62),
                    Color(red: 0.92, green: 0.18, blue: 0.42)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .info:
            // Calm informational blue
            return LinearGradient(
                colors: [
                    Color(red: 0.36, green: 0.72, blue: 1.0),
                    Color(red: 0.12, green: 0.48, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .warning:
            // Urgent orange
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.68, blue: 0.18),
                    Color(red: 0.92, green: 0.38, blue: 0.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

        case .done:
            // Success green
            return LinearGradient(
                colors: [
                    Color(red: 0.24, green: 0.86, blue: 0.44),
                    Color(red: 0.08, green: 0.64, blue: 0.28)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - AlxIcon
struct AlxIcon: View {

    let type: AlxIconType
    var showText: Bool
    var width: CGFloat
    var height: CGFloat
    var action: (() -> Void)?

    init(
        type: AlxIconType,
        showText: Bool = false,
        width: CGFloat = 72,
        height: CGFloat = 72,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.showText = showText
        self.width = width
        self.height = height
        self.action = action
    }

    var body: some View {
        Button {
            action?()
        } label: {
            ZStack {
                Rectangle().fill(type.gradient)

                VStack(spacing: 5) {
                    Spacer(minLength: 0)

                    Image(systemName: type.systemImage)
                        .font(.system(size: iconSize, weight: .semibold))
                        .foregroundStyle(.white)

                    if showText {
                        Text(type.label)
                            .font(.system(size: labelSize, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: width, height: height)
        .buttonStyle(.plain)
    }

    // Scale icon/label size theo chiều nhỏ hơn của frame
    private var minDimension: CGFloat { min(width, height) }

    private var iconSize: CGFloat {
        if showText {
            return max(minDimension * 0.28, 14)
        } else {
            return max(minDimension * 0.36, 16)
        }
    }

    private var labelSize: CGFloat {
        max(minDimension * 0.16, 10)
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {

            // Icon only (showText: false — default)
            Group {
                Text("Icon only (default)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach([
                            AlxIconType.delete, .save, .pin, .edit,
                            .share, .favorite, .info, .warning, .done
                        ], id: \.label) { type in
                            AlxIcon(type: type) {
                                print("\(type.label) tapped")
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }

            // Icon + Text (showText: true)
            Group {
                Text("Icon + Text (showText: true)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach([
                            AlxIconType.delete, .save, .pin, .edit,
                            .share, .favorite, .info, .warning, .done
                        ], id: \.label) { type in
                            AlxIcon(type: type, showText: true) {
                                print("\(type.label) tapped")
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }

            // Custom size
            Group {
                Text("Custom size")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                HStack(spacing: 16) {
                    AlxIcon(type: .delete, showText: true, width: 56, height: 56)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    AlxIcon(type: .save, showText: true, width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    AlxIcon(type: .pin, showText: true, width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    // Rectangular (dùng trong swipe card)
                    AlxIcon(type: .done, showText: true, width: 72, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal, 20)
            }

            // Ví dụ dùng trong AlxCard swipe
            Group {
                Text("Dùng trong AlxCard (swipeContent)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                        .frame(height: 64)
                        .overlay(
                            HStack {
                                Text("Vuốt trái để xoá →")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 16)
                                Spacer()
                            }
                        )
                        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)

                    AlxIcon(type: .delete, showText: true, width: 72, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 32)
    }
    .background(Color(.systemGroupedBackground))
}
