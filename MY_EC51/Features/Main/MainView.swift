//
//  MainView.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Dashboard (Nội dung hiện tại của MainView)
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            // Tab 2: Product
            ProductView()
                .tabItem {
                    Label("Product", systemImage: "cube.box.fill")
                }
                .tag(1)
            
            // Tab 3: Inventory
            InventoryView()
                .tabItem {
                    Label("Inventory", systemImage: "shippingbox.fill")
                }
                .tag(2)
            
            // Tab 4: Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(3)
        }
        .accentColor(.blue)
        .onAppear() {
            // Thiết lập màu nền trắng cho tab bar
            UITabBar.appearance().backgroundColor = UIColor.white
        }
    }
}

#Preview {
    MainView()
}
