//
//  AlxBasicLayout.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

struct AlxBaseLayout<Content: View>: View {
    let title: String
    let icon: String?
    let subtitle: String?
    let content: Content

    init(
        title: String,
        icon: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            AlxScreenHeader(
                title: title,
                icon: icon,
                subtitle: subtitle
            ) {
                
            }
            
            VStack {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(8)
            .beigeBackground()
        }
    }
}

#Preview {
    AlxBaseLayout(
        title: "Dashboard",
        icon: "person.circle.fill",
        subtitle: "Preview User"
    ) {
        VStack {
            Text("Dashboard Content")
                .font(.largeTitle)
            Text("Your content here")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
    }
}

