//
//  BackgroundBeige.swift
//  MY_EC51
//
//  Created by MacOS on 12/05/2026.
//

import SwiftUI

struct BackgroundBeige: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color(AlxColor.beige)
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func beigeBackground() -> some View {
        modifier(BackgroundBeige())
    }
}

