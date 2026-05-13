//
//  LoginViewModel.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import Foundation

@Observable
class LoginViewModel {
    var username: String = String()
    var password: String = String()
                    
    func checkInput() -> Bool {
        var res: Bool = true;
        if username.isEmpty{
            res = false;
        }
        if password.isEmpty{
            res = false;
        }
        
        if !res {
            username = String()
            password = String()
        }
        
        return true;
    }
    
    func handleSignIn() {
        if(!checkInput()){
            return;
        }
        print(username,password)
    }
}
