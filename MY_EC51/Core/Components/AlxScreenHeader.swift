//
//  AlxScreenHeader.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

struct AlxScreenHeader<Accessory: View>: View {
    let title: String
    let icon: String?
    let subtitle: String?
    let accessory: Accessory
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }

    var displaySubtitle: String {
        subtitle ?? formattedDate
    }

    init(
        title: String,
        icon: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.accessory = accessory()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                AlxText(displaySubtitle, style: .subheadline, color: .gray)
                
                HStack(alignment: .center, spacing: 4) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.title)
                            .foregroundStyle(.blue)
                    }
                    
                    AlxText(title, style: .title)
                }
            }
            
            Spacer()
            
            accessory
        }
        .padding(.horizontal)
    }
}

extension AlxScreenHeader where Accessory == EmptyView {
    init(
        title: String,
        icon: String? = nil,
        subtitle: String? = nil
    ) {
        self.init(title: title, icon: icon, subtitle: subtitle) {
            EmptyView()
        }
    }
}

#Preview {
    AlxScreenHeader(
        title: "Dashboard",
        icon: "person.circle.fill",
        subtitle: "Preview User"
    ) {
        Image(systemName: "person.circle.fill")
            .font(.system(size: 30))
            .foregroundColor(.blue)
            .onTapGesture {
                print("Profile tapped")
            }
    }
}
