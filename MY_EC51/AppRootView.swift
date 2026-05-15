//
//  AppRootView.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import SwiftUI

struct AppRootView: View {
    let environment: AppEnvironment

    var body: some View {
        AppBackground {
            if environment.appState.isAuthenticated {
                environment.makeMainView()
            } else {
                environment.makeLoginView()
            }
        }
    }
}

#Preview {
    AppRootView(environment: .preview())
}
