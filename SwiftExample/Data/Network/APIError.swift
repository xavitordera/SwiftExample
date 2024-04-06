import Foundation

enum APIError: Error {
    case noData
    case forbidden
    case unauthorized
    case decodingError(String)
    case generic(String)
    case unknown(Error)
}
