//
//  LoginView.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel = LoginViewModel()
    
    var body: some View {
        VStack() {
            Text("EC51 DEMO")
                .font(.largeTitle).fontWeight(.bold)
                .kerning(1.0)
                .padding(.bottom, 12)
            
            AlxTextField(
                "Username",
                text: $viewModel.username,
                title: "Username",
                systemImage: "person",
                textContentType: .username,
                submitLabel: .next
            ).padding(.bottom, 4)
            
            AlxTextField(
                "Password",
                text: $viewModel.password,
                title: "Password",
                systemImage: "lock",
                isSecure: true,
                textContentType: .password,
                submitLabel: .go
            ) {
                viewModel.handleSignIn()
            }.padding(.bottom, 12)

            AlxButton("SIGN IN", variant: .primary) {
                viewModel.handleSignIn()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    LoginView()
}
