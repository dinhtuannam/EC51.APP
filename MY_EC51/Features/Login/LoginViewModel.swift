//
//  LoginViewModel.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import Foundation
import Observation

@Observable
final class LoginViewModel {
    var username = ""
    var password = ""
    var usernameError: String?
    var passwordError: String?
    var errorMessage: String?
    var isLoading = false

    @ObservationIgnored private let loginUseCase: any LoginUseCaseProtocol
    @ObservationIgnored private let navigationCoordinator: any NavigationCoordinating

    init(
        loginUseCase: any LoginUseCaseProtocol,
        navigationCoordinator: any NavigationCoordinating
    ) {
        self.loginUseCase = loginUseCase
        self.navigationCoordinator = navigationCoordinator
    }

    @MainActor
    func checkInput() -> Bool {
        usernameError = nil
        passwordError = nil
        errorMessage = nil

        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedUsername.isEmpty {
            usernameError = "Username is required."
        }

        if password.isEmpty {
            passwordError = "Password is required."
        }

        return usernameError == nil && passwordError == nil
    }

    @MainActor
    func handleSignIn() {
        guard !isLoading, checkInput() else {
            return
        }

        Task {
            await login()
        }
    }

    @MainActor
    private func login() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let session = try await loginUseCase.execute(
                username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )

            navigationCoordinator.showMain(session: session)
            password = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
