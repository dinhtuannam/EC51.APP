//
//  UserSessionStore.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

enum AuthStorageKey {
    static let token = "authToken"
    static let userId = "authUserId"
    static let fullName = "authFullName"
    static let username = "authUsername"
    static let email = "authEmail"
    static let role = "authRole"
}

protocol UserSessionStoreProtocol {
    func loadSession() -> UserSession?
    func saveSession(_ session: UserSession)
    func clearSession()
}

final class UserDefaultsUserSessionStore: UserSessionStoreProtocol {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadSession() -> UserSession? {
        guard
            let token = userDefaults.string(forKey: AuthStorageKey.token),
            !token.isEmpty,
            let fullName = userDefaults.string(forKey: AuthStorageKey.fullName),
            let username = userDefaults.string(forKey: AuthStorageKey.username),
            let email = userDefaults.string(forKey: AuthStorageKey.email),
            let role = userDefaults.string(forKey: AuthStorageKey.role)
        else {
            return nil
        }

        let user = UserSession.User(
            id: userDefaults.integer(forKey: AuthStorageKey.userId),
            fullName: fullName,
            username: username,
            email: email,
            role: role
        )

        return UserSession(token: token, user: user)
    }

    func saveSession(_ session: UserSession) {
        userDefaults.set(session.token, forKey: AuthStorageKey.token)
        userDefaults.set(session.user.id, forKey: AuthStorageKey.userId)
        userDefaults.set(session.user.fullName, forKey: AuthStorageKey.fullName)
        userDefaults.set(session.user.username, forKey: AuthStorageKey.username)
        userDefaults.set(session.user.email, forKey: AuthStorageKey.email)
        userDefaults.set(session.user.role, forKey: AuthStorageKey.role)
    }

    func clearSession() {
        [
            AuthStorageKey.token,
            AuthStorageKey.userId,
            AuthStorageKey.fullName,
            AuthStorageKey.username,
            AuthStorageKey.email,
            AuthStorageKey.role
        ].forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}

final class InMemoryUserSessionStore: UserSessionStoreProtocol {
    private var session: UserSession?

    func loadSession() -> UserSession? {
        session
    }

    func saveSession(_ session: UserSession) {
        self.session = session
    }

    func clearSession() {
        session = nil
    }
}
