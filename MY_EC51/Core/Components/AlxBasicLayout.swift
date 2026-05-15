//
//  AlxBasicLayout.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

struct AlxBaseLayout: View {
    let title: String
    let icon: String?
    let subtitle: String?
    let content: AnyView

    init<Content: View>(
        title: String,
        icon: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.content = AnyView(content())
    }

    var body: some View {
        VStack(spacing: 0) {
            AlxScreenHeader(
                title: title,
                icon: icon,
                subtitle: subtitle
            )
            
            VStack {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(8)
            .background(AlxColor.appBackground)
        }
        .background(AlxColor.appBackground.ignoresSafeArea())
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
