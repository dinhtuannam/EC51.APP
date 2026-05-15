//
//  TopSellingProductView.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

struct TopSellingProductView: View {
    var body: some View {
        AlxCard(swipeDirection: .left, backgroundColor: Color(AlxColor.gray)) {
            HStack(spacing: 8) {
                AsyncImage(
                    url: URL(string: "https://images.unsplash.com/photo-1591337676887-a217a6970a8a")
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 54, height: 54)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Microsoft 365 Business")
                        .font(.system(size: 20, weight: .medium))
                    HStack(spacing: 3) {
                        Text("Quantity:")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.secondary)
                            .blur(radius: 0.3)
                        Text("25")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                Spacer()
                Image(systemName: "chevron.left")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
        } swipeContent: {
            AlxIcon(type: .info)
        }.background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    TopSellingProductView()
}
