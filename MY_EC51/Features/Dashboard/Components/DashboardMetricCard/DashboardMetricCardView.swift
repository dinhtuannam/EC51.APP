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
            Text("Revenue")
                .font(.title2)
                .fontWeight(.bold)
                .kerning(1.5)
                .padding(.leading, 4)
            Text("390,496$")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .kerning(1.5)
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
    return LazyVGrid(columns: columns) {
        ForEach(0..<4) { _ in
            DashboardMetricCardView().padding(2)
        }
    }
    .padding()
    .beigeBackground()
}
