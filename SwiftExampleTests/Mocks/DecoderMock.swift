@testable import SwiftExample
import Foundation
import XCTest

final class DecoderMock: DecoderProtocol {
    var decodeResult: Result<Decodable, Error> = .failure(APIError.generic("Error"))

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        switch decodeResult {
        case .success(let decodable):
            return try XCTUnwrap(decodable as? T)
        case .failure(let error):
            throw error
        }
    }
}
