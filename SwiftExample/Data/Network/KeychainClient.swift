import Foundation
import Security

protocol KeychainClientProtocol {
    @discardableResult func save(key: String, data: Data) -> OSStatus
    func load(key: String) -> Data?
    @discardableResult func delete(key: String) -> OSStatus
}

struct KeychainClient: KeychainClientProtocol {
    private let service = "com.swiftexample"

    enum Keys {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }

    @discardableResult
    func save(key: String, data: Data) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue as Any
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }

        return data
    }

    @discardableResult
    func delete(key: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        return SecItemDelete(query as CFDictionary)
    }
}

extension KeychainClientProtocol {
    func requestAccessToken() -> String? {
        if let data = load(key: KeychainClient.Keys.accessToken) {
            String(decoding: data, as: UTF8.self)
        } else {
            nil
        }
    }

    func requestRefreshToken() -> String? {
        if let data = load(key: KeychainClient.Keys.refreshToken) {
            String(decoding: data, as: UTF8.self)
        } else {
            nil
        }
    }
}
