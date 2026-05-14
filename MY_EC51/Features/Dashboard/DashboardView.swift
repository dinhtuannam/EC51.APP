//
//  DashboardView.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

struct DashboardView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        AlxBaseLayout(title: "Dashboard", icon: "person.circle.fill") {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<4) { _ in
                    DashboardMetricCardView()
                        .padding(2)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    DashboardView().beigeBackground()
}
