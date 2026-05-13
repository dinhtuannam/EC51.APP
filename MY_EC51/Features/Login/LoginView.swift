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
        VStack(spacing: 10) {
            Text("EC51 DEMO")
                .font(.largeTitle).fontWeight(.bold)
                .kerning(1.0)
            
            TextField("Username", text: $viewModel.username)
            TextField("Password", text: $viewModel.password)

            AlxButton("SIGN IN",variant: .primary ) {
                viewModel.handleSignIn()
            }
        }.padding(.horizontal)
            .background(Color.blue)
            .ignoresSafeArea()
    }
}

#Preview {
    LoginView()
}
