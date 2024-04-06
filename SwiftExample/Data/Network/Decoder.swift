import Foundation

protocol DecoderProtocol {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

final class Decoder: JSONDecoder, DecoderProtocol {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
