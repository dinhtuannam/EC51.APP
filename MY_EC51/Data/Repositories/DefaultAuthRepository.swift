//
//  DefaultAuthRepository.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

final class DefaultAuthRepository: AuthRepository {
    private let apiService: any AuthAPIServiceProtocol
    private let sessionStore: any UserSessionStoreProtocol

    init(
        apiService: any AuthAPIServiceProtocol,
        sessionStore: any UserSessionStoreProtocol
    ) {
        self.apiService = apiService
        self.sessionStore = sessionStore
    }

    func login(username: String, password: String) async throws -> UserSession {
        let response = try await apiService.login(username: username, password: password)
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

