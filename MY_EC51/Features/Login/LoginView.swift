//
//  LoginView.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import SwiftUI

struct LoginView: View {
    @State private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            AlxText("EC51 DEMO", style: .display, tracking: 2)
                .padding(.bottom, 12)
            
            AlxTextField(
                "Username",
                text: $viewModel.username,
                title: "Username",
                systemImage: "person",
                errorText: viewModel.usernameError,
                isDisabled: viewModel.isLoading,
                textContentType: .username,
                submitLabel: .next
            ).padding(.bottom, 4)
            
            AlxTextField(
                "Password",
                text: $viewModel.password,
                title: "Password",
                systemImage: "lock",
                errorText: viewModel.passwordError,
                isSecure: true,
                isDisabled: viewModel.isLoading,
                textContentType: .password,
                submitLabel: .go
            ) {
                viewModel.handleSignIn()
            }.padding(.bottom, 12)
            
            if let errorMessage = viewModel.errorMessage {
                AlxText(errorMessage, style: .footnote, color: AlxColor.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
            }
            
            AlxButton(
                "SIGN IN",
                loadingTitle: "SIGNING IN",
                variant: .primary,
                isLoading: viewModel.isLoading
            ) {
                viewModel.handleSignIn()
            }
        }
        .padding(.horizontal)
        .offset(y: -50)
    }
}

#Preview {
    AppBackground {
        AppEnvironment.preview()
            .makeLoginView()
    }
}
