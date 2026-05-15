//
//  AlxAsyncImage.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import SwiftUI
import UIKit

private final class AlxImageCache {
    static let shared = AlxImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct AlxAsyncImage: View {
    private enum Phase {
        case idle
        case loading
        case success(UIImage)
        case failure
    }

    let url: URL?
    var preview = false
    var contentMode: ContentMode = .fill
    var cornerRadius: CGFloat = 0
    var backgroundColor: Color = AlxColor.gray

    @State private var phase: Phase = .idle
    @State private var isPreviewPresented = false

    var body: some View {
        ZStack {
            content
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .task(id: url) {
            await loadImage()
        }
        .highPriorityGesture(
            TapGesture().onEnded {
                guard preview, image != nil else {
                    return
                }

                isPreviewPresented = true
            }
        )
        .fullScreenCover(isPresented: $isPreviewPresented) {
            if let image {
                AlxImagePreview(image: image)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch phase {
        case .idle, .loading:
            AlxImageSkeleton()
        case .success(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failure:
            Image(systemName: "photo")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(AlxColor.disabled)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var image: UIImage? {
        if case .success(let image) = phase {
            return image
        }

        return nil
    }

    @MainActor
    private func loadImage() async {
        guard let url else {
            phase = .failure
            return
        }

        if let cachedImage = AlxImageCache.shared.image(for: url) {
            phase = .success(cachedImage)
            return
        }

        phase = .loading

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let loadedImage = UIImage(data: data)
            else {
                phase = .failure
                return
            }

            AlxImageCache.shared.setImage(loadedImage, for: url)
            phase = .success(loadedImage)
        } catch {
            phase = .failure
        }
    }
}

private struct AlxImageSkeleton: View {
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width

            ZStack {
                AlxColor.border.opacity(0.35)

                LinearGradient(
                    colors: [
                        .clear,
                        Color.white.opacity(0.55),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: max(width * 0.65, 48))
                .offset(x: isAnimating ? width : -width)
            }
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.15).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
        }
    }
}

private struct AlxImagePreview: View {
    let image: UIImage

    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var saveMessage: String?
    @State private var isChromeVisible = true

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.05, green: 0.07, blue: 0.12),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()

            RadialGradient(
                colors: [
                    AlxColor.primary.opacity(0.28),
                    .clear
                ],
                center: .topTrailing,
                startRadius: 40,
                endRadius: 360
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
                .shadow(color: .black.opacity(0.45), radius: 24, x: 0, y: 18)
                .padding(.horizontal, 10)
                .gesture(zoomGesture.simultaneously(with: dragGesture))
                .onTapGesture(count: 2) {
                    resetZoom()
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.18)) {
                        isChromeVisible.toggle()
                    }
                }

            if isChromeVisible {
                previewChrome
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .zIndex(10)
            }
        }
        .statusBarHidden()
    }

    private var previewChrome: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    AlxText("Preview", style: .headline, color: .white)
                    AlxText(scaleText, style: .caption, color: .white.opacity(0.68))
                }

                Spacer()

                previewButton(systemImage: "square.and.arrow.down") {
                    saveImage()
                }

                previewButton(systemImage: "xmark") {
                    dismiss()
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.62),
                        Color.black.opacity(0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .top)
            )

            Spacer()

            if let saveMessage {
                AlxText(saveMessage, style: .footnote, color: .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.16))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.24), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 16, x: 0, y: 8)
                    .transition(.scale(scale: 0.92).combined(with: .opacity))
                    .padding(.bottom, 28)
            } else {
                AlxText("Pinch to zoom - double tap to reset", style: .caption, color: .white.opacity(0.62))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color.black.opacity(0.28)))
                    .padding(.bottom, 28)
            }
        }
    }

    private var scaleText: String {
        scale > 1.01 ? "\(Int(scale * 100))% zoom" : "Tap image to hide controls"
    }

    private func previewButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .semibold))
                .frame(width: 42, height: 42)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(
            Circle()
                .fill(Color.white.opacity(0.15))
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.22), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.28), radius: 12, x: 0, y: 6)
    }

    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = min(max(lastScale * value, 1), 5)
            }
            .onEnded { _ in
                lastScale = scale
                if scale == 1 {
                    offset = .zero
                    lastOffset = .zero
                }
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard scale > 1 else {
                    return
                }

                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }

    private func resetZoom() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
            scale = 1
            lastScale = 1
            offset = .zero
            lastOffset = .zero
        }
    }

    private func saveImage() {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
            saveMessage = "Saved to Photos"
            isChromeVisible = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.2)) {
                saveMessage = nil
            }
        }
    }
}

#Preview {
    AlxAsyncImage(
        url: URL(string: "https://images.unsplash.com/photo-1591337676887-a217a6970a8a"),
        preview: true,
        cornerRadius: 12
    )
    .frame(width: 120, height: 120)
    .padding()
    .background(AlxColor.appBackground)
}
