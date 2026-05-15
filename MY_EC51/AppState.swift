//
//  AppState.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation
import Observation
import SwiftUI

enum AppTab: Int, CaseIterable, Hashable {
    case dashboard
    case product
    case inventory
    case profile
}

@Observable
final class AppState {
    var currentSession: UserSession?
    var selectedTab: AppTab = .dashboard
    var dashboardPath = NavigationPath()
    var productPath = NavigationPath()
    var inventoryPath = NavigationPath()
    var profilePath = NavigationPath()

    var isAuthenticated: Bool {
        guard let token = currentSession?.token else {
            return false
        }

        return !token.isEmpty
    }

    init(sessionStore: any UserSessionStoreProtocol) {
        self.currentSession = sessionStore.loadSession()
    }

    func apply(session: UserSession) {
        currentSession = session
        selectedTab = .dashboard
    }
}

