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
    
    var body: some View {
        AlxBaseLayout(title: "Dashboard", icon: "house.fill") {
            LazyVGrid(columns: columns) {
                ForEach(0..<4) { _ in
                    DashboardMetricCardView()
                        .padding(2)
                }
            }
            AlxCard(title: "Top selling product") {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        TopSellingProductView()
                        TopSellingProductView()
                        TopSellingProductView()
                        TopSellingProductView()
                        TopSellingProductView()
                        TopSellingProductView()
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    DashboardView()
}
