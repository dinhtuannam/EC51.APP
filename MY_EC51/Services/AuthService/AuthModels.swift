//
//  AuthModels.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
    let user: AuthUser
}

struct AuthUser: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let email: String
    let role: String
}

enum AuthStorageKey {
    static let token = "authToken"
    static let userId = "authUserId"
    static let fullName = "authFullName"
    static let username = "authUsername"
    static let email = "authEmail"
    static let role = "authRole"
}
