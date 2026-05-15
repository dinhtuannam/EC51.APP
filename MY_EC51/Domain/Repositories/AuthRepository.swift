//
//  AuthRepository.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

protocol AuthRepository {
    func login(username: String, password: String) async throws -> UserSession
}

