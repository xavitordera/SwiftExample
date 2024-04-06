import Foundation

typealias DataTaskResult = @Sendable (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol APIClientProtocol {
    func request<T>(request: URLRequest) async throws -> T where T : Decodable
}

struct APIClient: APIClientProtocol {
    private let urlSession: URLSessionProtocol
    private let decoder: DecoderProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared,
         decoder: DecoderProtocol = Decoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func request<T>(request: URLRequest) async throws -> T where T : Decodable  {
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.noData
        }

        switch response.statusCode {
        case 200...299: break
        case 401, 403: throw APIError.forbidden
        default: throw APIError.generic("Error code: \(response.statusCode)")
        }
        
        return try decoder.decode(T.self, from: data)
    }
}
