//
//  AppEnvironment.swift
//  MY_EC51
//
//  Created by Codex on 15/05/2026.
//

import Foundation

final class AppEnvironment {
    let appState: AppState

    private let loginUseCase: any LoginUseCaseProtocol
    private let navigationCoordinator: any NavigationCoordinating

    init(
        appState: AppState,
        loginUseCase: any LoginUseCaseProtocol,
        navigationCoordinator: any NavigationCoordinating
    ) {
        self.appState = appState
        self.loginUseCase = loginUseCase
        self.navigationCoordinator = navigationCoordinator
    }

    static func live() -> AppEnvironment {
        let apiClient = APIClient.shared
        let sessionStore = UserDefaultsUserSessionStore()
        let appState = AppState(sessionStore: sessionStore)
        let authAPIService = AuthAPIService(apiClient: apiClient)
        let authRepository = DefaultAuthRepository(
            apiService: authAPIService,
            sessionStore: sessionStore
        )
        let loginUseCase = LoginUseCase(authRepository: authRepository)
        let navigationCoordinator = NavigationCoordinator(appState: appState)

        apiClient.tokenProvider = {
            sessionStore.loadSession()?.token
        }

        return AppEnvironment(
            appState: appState,
            loginUseCase: loginUseCase,
            navigationCoordinator: navigationCoordinator
        )
    }

    static func preview() -> AppEnvironment {
        let sessionStore = InMemoryUserSessionStore()
        let appState = AppState(sessionStore: sessionStore)
        let loginUseCase = PreviewLoginUseCase()
        let navigationCoordinator = NavigationCoordinator(appState: appState)

        return AppEnvironment(
            appState: appState,
            loginUseCase: loginUseCase,
            navigationCoordinator: navigationCoordinator
        )
    }

    func makeLoginView() -> LoginView {
        LoginView(
            viewModel: LoginViewModel(
                loginUseCase: loginUseCase,
                navigationCoordinator: navigationCoordinator
            )
        )
    }

    func makeMainView() -> MainView {
        MainView(appState: appState)
    }
}

