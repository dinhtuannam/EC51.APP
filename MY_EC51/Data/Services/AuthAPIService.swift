//
//  AuthAPIService.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

protocol AuthAPIServiceProtocol {
    func login(username: String, password: String) async throws -> LoginResponseDTO
}

final class AuthAPIService: AuthAPIServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }

    func login(username: String, password: String) async throws -> LoginResponseDTO {
        try await apiClient.request(
            "/api/auth/login",
            method: .post,
            body: LoginRequest(username: username, password: password),
            responseType: LoginResponseDTO.self
        )
    }
}

