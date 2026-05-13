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
        if viewModel.isLoggedIn {
            MainView()
        } else {
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
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(AlxColor.error)
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
        }
    }
}

#Preview {
    LoginView()
}
