//
//  AppBackground.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import SwiftUI

struct AppBackground<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            AlxColor.appBackground
                .ignoresSafeArea()

            content
        }
    }
}

