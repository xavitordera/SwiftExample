import XCTest
@testable import SwiftExample

class KeychainClientTests: XCTestCase {
    var keychainClient: KeychainClient!

    override func setUp() {
        super.setUp()
        keychainClient = KeychainClient()
    }

    override func tearDown() {
        keychainClient = nil
        super.tearDown()
    }

    func testSaveAndLoad() {
        let accessTokenData = "MockAccessToken".data(using: .utf8)!

        XCTAssertEqual(keychainClient.save(key: KeychainClient.Keys.accessToken, data: accessTokenData), errSecSuccess)

        let loadedAccessToken = keychainClient.load(key: KeychainClient.Keys.accessToken)

        XCTAssertNotNil(loadedAccessToken)
        XCTAssertEqual(loadedAccessToken, accessTokenData)
    }

    func testDelete() {
        let refreshTokenData = "MockRefreshToken".data(using: .utf8)!

        keychainClient.save(key: KeychainClient.Keys.refreshToken, data: refreshTokenData)
        XCTAssertEqual(keychainClient.delete(key: KeychainClient.Keys.refreshToken), errSecSuccess)

        let loadedRefreshToken = keychainClient.load(key: KeychainClient.Keys.refreshToken)
        XCTAssertNil(loadedRefreshToken)
    }

    func testRequestAccessToken() {
        let accessTokenData = "MockAccessToken".data(using: .utf8)!

        keychainClient.save(key: KeychainClient.Keys.accessToken, data: accessTokenData)

        let loadedAccessToken = keychainClient.requestAccessToken()

        XCTAssertNotNil(loadedAccessToken)
        XCTAssertEqual(loadedAccessToken, "MockAccessToken")
    }

    func testRequestRefreshToken() {
        let refreshTokenData = "MockRefreshToken".data(using: .utf8)!

        keychainClient.save(key: KeychainClient.Keys.refreshToken, data: refreshTokenData)

        let loadedRefreshToken = keychainClient.requestRefreshToken()

        XCTAssertNotNil(loadedRefreshToken)
        XCTAssertEqual(loadedRefreshToken, "MockRefreshToken")
    }
}
