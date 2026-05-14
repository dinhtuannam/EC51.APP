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
    let content: Content

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }

    var subtitle: String {
        return UserDefaults.standard.string(forKey: "userFullName") ?? formattedDate
    }

    init(
        title: String,
        icon: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            AlxScreenHeader(
                title: title,
                icon: icon
            ) {
                
            }
            
            VStack(){
                content
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(8)
        }
    }
}

#Preview {
    AlxBaseLayout(
        title: "Dashboard",
        icon: "person.circle.fill"
    ) {
        VStack {
            Text("Dashboard Content")
                .font(.largeTitle)
            Text("Your content here")
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
    }
}
