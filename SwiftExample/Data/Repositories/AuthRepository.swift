import Foundation

protocol AuthRepositoryProtocol {
    func logout()
    func isTokenValid() async -> Bool
    func login(username: String, password: String) async throws
}

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct AuthRepository: AuthRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let keyChainClient: KeychainClientProtocol

    init(apiClient: APIClientProtocol,
         keyChainClient: KeychainClientProtocol) {
        self.apiClient = apiClient
        self.keyChainClient = keyChainClient
    }

    private func login(using endpoint: APIEndpoint) async throws {
        let response: LoginResponse = try await apiClient.request(request: endpoint.urlRequest())
        keyChainClient.save(
            key: KeychainClient.Keys.accessToken,
            data: Data(response.accessToken.utf8)
        )
        keyChainClient.save(
            key: KeychainClient.Keys.refreshToken,
            data: Data(response.refreshToken.utf8)
        )
    }

    func logout() {
        keyChainClient.delete(key: KeychainClient.Keys.accessToken)
        keyChainClient.delete(key: KeychainClient.Keys.refreshToken)
    }
    
    func isTokenValid() async -> Bool {
        guard let refreshToken = keyChainClient.requestRefreshToken(),
              let _ = try? await login(using: .authentication(.refreshToken(refreshToken))) else {
            return false
        }
        return true
    }
    
    func login(username: String, password: String) async throws {
        try await login(using: .authentication(.getToken(username: username, password: password)))
    }
}

#if targetEnvironment(simulator)

final class AuthRepositoryMock: AuthRepositoryProtocol {
    func isTokenValid() async -> Bool {
        false
    }
    
    func login(username: String, password: String) async throws {
        fatalError()
    }
    
    var isTokenValidResult: Bool = false
    var loginResult: Result<SwiftExample.LoginResponse, SwiftExample.APIError> = .success(.init(accessToken: "accessToken", refreshToken: "refreshToken"))
    var logoutCalled = false

    func logout() {
        logoutCalled = true
    }
}

#endif
