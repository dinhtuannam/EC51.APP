//
//  AuthService.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import Foundation

protocol AuthServiceProtocol {
    func login(username: String, password: String) async throws -> LoginResponse
}

final class AuthService: AuthServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func login(username: String, password: String) async throws -> LoginResponse {
        try await apiClient.request(
            "/api/auth/login",
            method: .post,
            body: LoginRequest(username: username, password: password),
            responseType: LoginResponse.self
        )
    }
}
