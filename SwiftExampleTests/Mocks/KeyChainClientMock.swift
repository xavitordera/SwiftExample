import Foundation
@testable import SwiftExample

class KeyChainClientMock: KeychainClientProtocol {
    private var keychainStorage: [String: Data] = [:]

    @discardableResult
    func save(key: String, data: Data) -> OSStatus {
        keychainStorage[key] = data
        return errSecSuccess
    }

    func load(key: String) -> Data? {
        return keychainStorage[key]
    }

    @discardableResult
    func delete(key: String) -> OSStatus {
        keychainStorage.removeValue(forKey: key)
        return errSecSuccess
    }
}
