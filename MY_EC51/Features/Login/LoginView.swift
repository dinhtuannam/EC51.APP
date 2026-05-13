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
            
            TextField("Placeholder", text: /*@PLACEHOLDER=Value@*/.constant(""))
            TextField("Placeholder", text: /*@PLACEHOLDER=Value@*/.constant(""))

            AlxButton("SIGN IN") {

            }.padding(.horizontal)
        }
    }
}

#Preview {
    LoginView()
}
