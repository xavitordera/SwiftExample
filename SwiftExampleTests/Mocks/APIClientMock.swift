@testable import SwiftExample
import Foundation

final class URLSessionMock: URLSessionProtocol {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (SwiftExample.DataTaskResult)
    ) -> URLSessionDataTask {
        completionHandler(data, response, error)
        return URLSessionDataTaskMock()
    }
}

final class URLSessionDataTaskMock: URLSessionDataTask {
    override func resume() {}
}

final class APIClientMock: APIClientProtocol {
    var result: Result<Decodable, APIError>?

    func request<T>(request: URLRequest, completion: @escaping (Result<T, SwiftExample.APIError>) -> Void) where T : Decodable {


            switch result {
            case .success(let response):
                if let decodable = response as? T {
                    completion(.success(decodable))
                } else {
                    completion(.failure(.generic("Error")))
                }
            case .failure(let error):
                completion(.failure(error))
            case .none:
                completion(.failure(.generic("Error")))
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
