//
//  AuthDTOs.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}

struct LoginResponseDTO: Decodable {
    let token: String
    let user: AuthUserDTO
}

struct AuthUserDTO: Decodable {
    let id: Int
    let fullName: String
    let username: String
    let email: String
    let role: String
}

