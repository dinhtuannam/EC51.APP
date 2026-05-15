//
//  MY_EC51App.swift
//  MY_EC51
//
//  Created by MacOS on 12/05/2026.
//

import SwiftUI

@main
struct MY_EC51App: App {
    private let appEnvironment = AppEnvironment.live()

    var body: some Scene {
        WindowGroup {
            AppRootView(environment: appEnvironment)
        }
    }
}
