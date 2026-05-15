//
//  MainView.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

struct MainView: View {
    @Bindable var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack(path: $appState.dashboardPath) {
                DashboardView(subtitle: appState.currentSession?.user.fullName)
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            .tag(AppTab.dashboard)
            
            NavigationStack(path: $appState.productPath) {
                ProductView()
            }
            .tabItem {
                Label("Product", systemImage: "cube.box.fill")
            }
            .tag(AppTab.product)
            
            NavigationStack(path: $appState.inventoryPath) {
                InventoryView()
            }
            .tabItem {
                Label("Inventory", systemImage: "shippingbox.fill")
            }
            .tag(AppTab.inventory)
            
            NavigationStack(path: $appState.profilePath) {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle.fill")
            }
            .tag(AppTab.profile)
        }
        .tint(.blue)
        .toolbarBackground(.white, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    MainView(appState: AppEnvironment.preview().appState)
}

