//
//  AuthRepository.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let apiClient: APIClient
    private let sessionStore: any UserSessionStoreProtocol

    init(
        apiClient: APIClient = .shared,
        sessionStore: any UserSessionStoreProtocol
    ) {
        self.apiClient = apiClient
        self.sessionStore = sessionStore
    }

    func login(username: String, password: String) async throws -> UserSession {
        let response = try await apiClient.request(
            "/api/auth/login",
            method: .post,
            body: LoginRequest(username: username, password: password),
            responseType: LoginResponseDTO.self
        )
        let session = response.toDomain()

        sessionStore.saveSession(session)

        return session
    }
}

private extension LoginResponseDTO {
    func toDomain() -> UserSession {
        UserSession(
            token: token,
            user: UserSession.User(
                id: user.id,
                fullName: user.fullName,
                username: user.username,
                email: user.email,
                role: user.role
            )
        )
    }
}

