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

    func test_login_whenLoginSucceeds_shouldSaveTokens() async throws {
        // given
        let loginData = LoginResponse(accessToken: "token", refreshToken: "token refresh")
        apiClient.result = .success(loginData)

        // when
        try await systemUnderTest.login(username: "username", password: "password")
        // then
        XCTAssertEqual(self.keychain.requestAccessToken(), "token")
        XCTAssertEqual(self.keychain.requestRefreshToken(), "token refresh")
    }

    func test_login_whenLoginFails_shouldNotSaveTokens() async throws {
        // given
        apiClient.result = .failure(.generic(""))

        // when
        do {
            try await systemUnderTest.login(username: "username", password: "password")
            
            XCTFail()
        } catch let error {
            XCTAssertNil(self.keychain.requestAccessToken())
            XCTAssertNil(self.keychain.requestRefreshToken())
        }
    }

    func test_isTokenValid_whenTokenIsValid_shouldReturnTrue() async {
        // given
        let loginData = LoginResponse(accessToken: "token", refreshToken: "token refresh")
        apiClient.result = .success(loginData)
        keychain.save(key: KeychainClient.Keys.refreshToken, data: Data("".utf8))

        // when
        let isValid = await systemUnderTest.isTokenValid()
        
        // then
        XCTAssertTrue(isValid)
        XCTAssertEqual(self.keychain.requestAccessToken(), "token")
        XCTAssertEqual(self.keychain.requestRefreshToken(), "token refresh")
    }

    func test_isTokenValid_whenTokenIsInvalid_shouldReturnFalse() async {
        // given
        let loginData = LoginResponse(accessToken: "token", refreshToken: "token refresh")
        apiClient.result = .failure(.generic(""))

        // when
        let isValid = await systemUnderTest.isTokenValid()
        
        // then
        XCTAssertFalse(isValid)
        XCTAssertNil(self.keychain.requestAccessToken())
        XCTAssertNil(self.keychain.requestRefreshToken())
    }

    func test_logout_whenLogoutSucceeds_shouldRemoveTokens() async throws {
        // given
        let loginData = LoginResponse(accessToken: "token", refreshToken: "token refresh")
        apiClient.result = .success(loginData)
        
        try await systemUnderTest.login(username: "username", password: "password")
        // when
        systemUnderTest.logout()
        // then
        XCTAssertNil(self.keychain.requestAccessToken())
        XCTAssertNil(self.keychain.requestRefreshToken())
    }
}

