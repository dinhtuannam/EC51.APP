//
//  LoginUseCase.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute(username: String, password: String) async throws -> UserSession
}

struct LoginUseCase: LoginUseCaseProtocol {
    private let authRepository: any AuthRepository

    init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(username: String, password: String) async throws -> UserSession {
        try await authRepository.login(username: username, password: password)
    }
}

struct PreviewLoginUseCase: LoginUseCaseProtocol {
    func execute(username: String, password: String) async throws -> UserSession {
        UserSession(
            user: UserSession.User(
                id: 1,
                fullName: username.isEmpty ? "Preview User" : username,
                username: username,
                email: "preview@ec51.local",
                role: "Admin"
            )
        )
    }
}

