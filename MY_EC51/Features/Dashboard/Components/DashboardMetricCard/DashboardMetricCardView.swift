//
//  DashboardMetricCardView.swift
//  MY_EC51
//
//  Created by MacOS on 14/05/2026.
//

import SwiftUI

struct DashboardMetricCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 50)) // Size to hơn
                .foregroundColor(.blue)  // Màu xanh lá
            AlxText("Revenue", style: .title2, tracking: 1.5)
                .padding(.leading, 4)
            AlxText("390,496$", style: .title, tracking: 1.5)
                .padding(.leading, 4)
        }).frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(8)
            .background(Color.white)
            .cornerRadius(16)
    }
}

#Preview {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    return AppBackground {
        LazyVGrid(columns: columns) {
            ForEach(0..<4) { _ in
                DashboardMetricCardView().padding(2)
            }
        }
        .padding()
    }
}
