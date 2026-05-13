//
//  LoginViewModel.swift
//  MY_EC51
//
//  Created by MacOS on 13/05/2026.
//

import Foundation
import Observation

@Observable
class LoginViewModel {
    var username = ""
    var password = ""
    var usernameError: String?
    var passwordError: String?
    var errorMessage: String?
    var isLoading = false
    var isLoggedIn = false
    var currentUser: AuthUser?

    @ObservationIgnored private let authService: any AuthServiceProtocol
    @ObservationIgnored private let userDefaults: UserDefaults

    init(
        authService: any AuthServiceProtocol = AuthService(),
        userDefaults: UserDefaults = .standard
    ) {
        self.authService = authService
        self.userDefaults = userDefaults
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
            let response = try await authService.login(
                username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )

            saveSession(response)
            currentUser = response.user
            isLoggedIn = true
            password = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func saveSession(_ response: LoginResponse) {
        userDefaults.set(response.token, forKey: AuthStorageKey.token)
        userDefaults.set(response.user.id, forKey: AuthStorageKey.userId)
        userDefaults.set(response.user.fullName, forKey: AuthStorageKey.fullName)
        userDefaults.set(response.user.username, forKey: AuthStorageKey.username)
        userDefaults.set(response.user.email, forKey: AuthStorageKey.email)
        userDefaults.set(response.user.role, forKey: AuthStorageKey.role)
    }
}
