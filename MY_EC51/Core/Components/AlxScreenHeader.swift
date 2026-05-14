//
//  AlxScreenHeader.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

struct AlxScreenHeader<Content: View>: View {
    let title: String
    let icon: String?
    let content: Content?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }

    var subtitle: String {
        return UserDefaults.standard.string(forKey: AuthStorageKey.fullName) ?? formattedDate
    }

    // Init với content optional
    init(title: String, icon: String? = nil, @ViewBuilder content: () -> Content? = { nil }) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(alignment: .center, spacing: 4) {
                    // Icon chỉ hiển thị nếu có
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.title)
                            .foregroundStyle(.blue)
                    }
                    
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
            
            if let content = content {
                content
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    AlxScreenHeader(
        title: "Dashboard",
        icon: "person.circle.fill"
    ) {
        Image(systemName: "person.circle.fill")
            .font(.system(size: 30))
            .foregroundColor(.blue)
            .onTapGesture {
                print("Profile tapped")
            }
    }
}
