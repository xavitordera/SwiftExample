import Foundation

struct AppEnvironment {
    let authRepository: AuthRepositoryProtocol
    static let current = {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            AppEnvironment.mock
        } else {
            AppEnvironment.live
        }
    }()
}

extension AppEnvironment {
    static let live = Self(authRepository: AuthRepository(apiClient: APIClient(), keyChainClient: KeychainClient()))
    #if targetEnvironment(simulator)
    static let mock = Self(authRepository: AuthRepositoryMock())
    #endif
}
