//
//  AlxAppBackground.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

struct AlxAppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                AlxColor.backgroundTop,
                AlxColor.backgroundMiddle,
                AlxColor.backgroundBottom
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct AlxAppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AlxAppBackground()
            content
        }
    }
}

extension View {
    func alxAppBackground() -> some View {
        modifier(AlxAppBackgroundModifier())
    }
}

#Preview {
    Text("EC51")
        .font(.largeTitle)
        .fontWeight(.bold)
        .foregroundStyle(.white)
        .alxAppBackground()
}
