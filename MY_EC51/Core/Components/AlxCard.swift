//
//  AlxCard.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

// MARK: - Swipe Direction
enum SwipeDirection {
    case left, right
}

// MARK: - AlxCard
struct AlxCard<Content: View, SwipeContent: View>: View {

    // MARK: Props
    var title: String?
    var cornerRadius: CGFloat
    var swipeDirection: SwipeDirection
    var swipeThreshold: CGFloat
    var shadowColor: Color
    var backgroundColor: Color

    let content: Content
    let swipeContent: SwipeContent?

    // MARK: State
    @State private var offsetX: CGFloat = 0
    @State private var isRevealed: Bool = false

    private let revealWidth: CGFloat = 80

    // MARK: Init — có swipeContent
    init(
        title: String? = nil,
        cornerRadius: CGFloat = 16,
        swipeDirection: SwipeDirection = .left,
        swipeThreshold: CGFloat = 60,
        backgroundColor: Color = Color(.systemBackground),
        shadowColor: Color = Color.black.opacity(0.08),
        @ViewBuilder content: () -> Content,
        @ViewBuilder swipeContent: () -> SwipeContent
    ) {
        self.title = title
        self.cornerRadius = cornerRadius
        self.swipeDirection = swipeDirection
        self.swipeThreshold = swipeThreshold
        self.backgroundColor = backgroundColor
        self.shadowColor = shadowColor
        self.content = content()
        self.swipeContent = swipeContent()
    }

    // MARK: Body
    var body: some View {
        cardLayer
            .offset(x: offsetX)
            .animation(.spring(response: 0.38, dampingFraction: 0.78), value: offsetX)
            .gesture(swipeContent != nil ? dragGesture : nil)
            .background(alignment: swipeDirection == .left ? .trailing : .leading) {
                if let sc = swipeContent {
                    sc
                        .frame(width: revealWidth)
                        .opacity(revealOpacity)
                        .scaleEffect(
                            CGSize(width: revealScale, height: revealScale),
                            anchor: swipeDirection == .left ? .trailing : .leading
                        )
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                }
            }
            .shadow(color: shadowColor, radius: 10, x: 0, y: 4)
    }

    // MARK: - Card Layer
    private var cardLayer: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = title {
                titleHeader(title)
            }
            content
                .padding(.horizontal, 12)
                .padding(.vertical, title == nil ? 16 : 12)
                .padding(.bottom, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    // MARK: - Title Header
    @ViewBuilder
    private func titleHeader(_ title: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2)
                .fill(LinearGradient(
                    colors: [.blue, .indigo],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .frame(width: 3, height: 20)

            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .kerning(2)
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.top, 14)
        .padding(.bottom, 10)

        Divider()
            .padding(.horizontal, 12)
    }

    // MARK: - Drag Gesture
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                let translation = value.translation.width
                let isValidSwipe = swipeDirection == .left ? translation < 0 : translation > 0

                if isValidSwipe {
                    let base: CGFloat = isRevealed
                        ? (swipeDirection == .left ? -revealWidth : revealWidth)
                        : 0
                    let delta = (translation - (isRevealed ? (swipeDirection == .left ? -revealWidth : revealWidth) : 0)) * 0.85
                    let raw = base + delta
                    offsetX = swipeDirection == .left
                        ? max(raw, -revealWidth * 1.3)
                        : min(raw, revealWidth * 1.3)
                } else if isRevealed {
                    let base: CGFloat = swipeDirection == .left ? -revealWidth : revealWidth
                    offsetX = swipeDirection == .left
                        ? min(base + translation, 0)
                        : max(base + translation, 0)
                }
            }
            .onEnded { value in
                let translation = value.translation.width
                let velocity = value.predictedEndTranslation.width - translation

                let shouldReveal = swipeDirection == .left
                    ? (translation < -swipeThreshold || velocity < -200)
                    : (translation > swipeThreshold || velocity > 200)

                let shouldHide = swipeDirection == .left
                    ? (translation > swipeThreshold / 2 || velocity > 200)
                    : (translation < -swipeThreshold / 2 || velocity < -200)

                if isRevealed && shouldHide {
                    offsetX = 0
                    isRevealed = false
                } else if !isRevealed && shouldReveal {
                    offsetX = swipeDirection == .left ? -revealWidth : revealWidth
                    isRevealed = true
                } else {
                    offsetX = isRevealed
                        ? (swipeDirection == .left ? -revealWidth : revealWidth)
                        : 0
                }
            }
    }

    // MARK: - Computed helpers
    private var revealOpacity: Double {
        let progress = min(abs(offsetX) / revealWidth, 1.0)
        return Double(progress)
    }

    private var revealScale: CGFloat {
        let progress = min(abs(offsetX) / revealWidth, 1.0)
        return 0.7 + 0.3 * progress
    }
}

// MARK: - Init không có swipeContent (EmptyView)
extension AlxCard where SwipeContent == EmptyView {
    init(
        title: String? = nil,
        cornerRadius: CGFloat = 16,
        backgroundColor: Color = Color(.systemBackground),
        shadowColor: Color = Color.black.opacity(0.08),
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.cornerRadius = cornerRadius
        self.swipeDirection = .left
        self.swipeThreshold = 60
        self.backgroundColor = backgroundColor
        self.shadowColor = shadowColor
        self.content = content()
        self.swipeContent = nil
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {

            // ✅ Card KHÔNG có swipeContent
            AlxCard(title: "Top selling product") {
                Text("Hello")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }

            // Card with title + swipe left (delete)
            AlxCard(title: "Đơn hàng #1042") {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 44, height: 44)
                        .overlay(Image(systemName: "shippingbox.fill").foregroundStyle(.white))

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Áo thun basic trắng")
                            .font(.system(size: 15, weight: .medium))
                        Text("Số lượng: 2  ·  250.000đ")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.tertiary)
                }
            } swipeContent: {
                Button { print("Delete") } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Xoá")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        LinearGradient(colors: [.red, Color(red: 0.8, green: 0.1, blue: 0.1)],
                                       startPoint: .top, endPoint: .bottom)
                    )
                }
            }

            // Card without title + swipe right (pin)
            AlxCard(swipeDirection: .right, backgroundColor: Color(.secondarySystemBackground)) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text("AN")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.white)
                        )
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Anh Nguyễn")
                            .font(.system(size: 15, weight: .medium))
                        Text("Hãy kiểm tra đơn hàng nhé 👋")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    Text("10:24")
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                }
            } swipeContent: {
                Button { print("Pin") } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Ghim")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        LinearGradient(colors: [.indigo, .purple],
                                       startPoint: .top, endPoint: .bottom)
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 32)
    }
    .background(Color(.systemGroupedBackground))
}
