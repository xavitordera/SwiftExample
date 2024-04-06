@testable import SwiftExample
import XCTest

final class AuthRepositoryTests: XCTestCase {
    private var systemUnderTest: AuthRepository!
    private var apiClient: APIClientMock!
    private var keychain: KeyChainClientMock!

    override func setUp() {
        super.setUp()
        apiClient = APIClientMock()
        keychain = KeyChainClientMock()
        systemUnderTest = AuthRepository(apiClient: apiClient,
                                         keyChainClient: keychain)
    }

    override func tearDown() {
        systemUnderTest = nil
        keychain = nil
        apiClient = nil
        super.tearDown()
    }

    func test_login_whenLoginSucceeds_shouldSaveTokens() {
        // given
        let loginData = LoginResponse(accessToken: "token", refreshToken: "token refresh")
        apiClient.result = .success(loginData)

        // when
        systemUnderTest.login(username: "username", password: "password") { result in
            // then
            XCTAssertEqual(self.keychain.requestAccessToken(), "token")
            XCTAssertEqual(self.keychain.requestRefreshToken(), "token refresh")

            if case .success(let response) = result {
                XCTAssertEqual(response.accessToken, "token")
                XCTAssertEqual(response.refreshToken, "token refresh")
            } else {
                XCTFail()
            }
        }
    }

    func test_login_whenLoginFails_shouldNotSaveTokens() {
        // given
        apiClient.result = .failure(.generic(""))

        // when
        systemUnderTest.login(username: "username", password: "password") { result in
            // then
            XCTAssertNil(self.keychain.requestAccessToken())
            XCTAssertNil(self.keychain.requestRefreshToken())

            if case .failure = result {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
    }

    func test_isTokenValid_whenTokenIsValid_shouldReturnTrue() {
        // given
        let loginData = LoginResponse(accessToken: "token", refreshToken: "token refresh")
        apiClient.result = .success(loginData)
        keychain.save(key: KeychainClient.Keys.refreshToken, data: Data("".utf8))

        // when
        systemUnderTest.isTokenValid { isValid in
            XCTAssertTrue(isValid)
            XCTAssertEqual(self.keychain.requestAccessToken(), "token")
            XCTAssertEqual(self.keychain.requestRefreshToken(), "token refresh")
        }
    }

    func test_isTokenValid_whenTokenIsInvalid_shouldReturnFalse() {
        // given
        let loginData = LoginResponse(accessToken: "token", refreshToken: "token refresh")
        apiClient.result = .failure(.generic(""))

        // when
        systemUnderTest.isTokenValid { isValid in
            XCTAssertFalse(isValid)
            XCTAssertNil(self.keychain.requestAccessToken())
            XCTAssertNil(self.keychain.requestRefreshToken())
        }
    }

    func test_logout_whenLogoutSucceeds_shouldRemoveTokens() {
        // given
        let loginData = LoginResponse(accessToken: "token", refreshToken: "token refresh")
        apiClient.result = .success(loginData)

        systemUnderTest.login(username: "username", password: "password") { _ in
            // when
            self.systemUnderTest.logout()
            // then
            XCTAssertNil(self.keychain.requestAccessToken())
            XCTAssertNil(self.keychain.requestRefreshToken())
        }
    }
}

