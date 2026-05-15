//
//  UserSession.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

struct UserSession: Equatable {
    struct User: Equatable {
        let id: Int
        let fullName: String
        let username: String
        let email: String
        let role: String
    }

    let token: String
    let user: User
}

