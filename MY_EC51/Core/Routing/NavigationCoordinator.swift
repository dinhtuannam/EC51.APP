//
//  NavigationCoordinator.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

protocol NavigationCoordinating {
    @MainActor
    func showMain(session: UserSession)
}

final class NavigationCoordinator: NavigationCoordinating {
    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    @MainActor
    func showMain(session: UserSession) {
        appState.apply(session: session)
    }
}
