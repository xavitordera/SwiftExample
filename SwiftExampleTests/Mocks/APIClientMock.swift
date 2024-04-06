@testable import SwiftExample
import Foundation

final class URLSessionMock: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        if let data, let response  {
            return (data, response)
        }
        
        throw error ?? APIError.noData
    }
}

final class APIClientMock: APIClientProtocol {
    var result: Result<Decodable, APIError>?
    
    func request<T>(request: URLRequest) async throws -> T where T : Decodable {
        switch result {
        case .success(let response):
            return response as! T
        case .failure(let error):
            throw error
        case .none:
            throw APIError.noData
        }
    }
}

extension ArticleDetailsDataModel {
    static var mock: ArticleDetailsDataModel {
        .init(content: "content",
              date: "date",
              id: 1,
              imageUrl: "imageUrl",
              sourceUrl: "sourceUrl",
              summary: "summary",
              thumbnailTemplateUrl: "thumbnailTemplateUrl",
              thumbnailUrl: "thumbnailUrl",
              title: "title")
    }
}

extension ArticleDataModel {
    static var mock: ArticleDataModel {
        .init(date: "date",
              id: 1,
              summary: "summary",
              thumbnailTemplateUrl: "thumbnailTemplateUrl",
              thumbnailUrl: "thumbnailUrl",
              title: "title")
    }
}
