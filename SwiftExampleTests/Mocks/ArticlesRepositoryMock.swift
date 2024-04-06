@testable import SwiftExample
import Foundation

final class ArticlesRepositoryMock: ArticlesRepositoryProtocol {
    var fetchArticlesResult: Result<[ArticleUIModel], APIError> = .success([.mock])
    var fetchArticleDetailsResult: Result<ArticleDetailUIModel, APIError> = .success(.mock)

    func fetchArticles(completion: @escaping (Result<[SwiftExample.ArticleUIModel], SwiftExample.APIError>) -> Void) {
        completion(fetchArticlesResult)
    }
    
    func fetchArticleDetails(id: Int, completion: @escaping (Result<SwiftExample.ArticleDetailUIModel, SwiftExample.APIError>) -> Void) {
        completion(fetchArticleDetailsResult)
    }
}

extension ArticleUIModel {
    static var mock: ArticleUIModel {
        .init(title: "title",
              summary: "summary",
              thumbnailURL: nil,
              date: "date",
              id: 0)
    }
}

extension ArticleDetailUIModel {
    static var mock: ArticleDetailUIModel {
        .init(content: "content",
              date: "date",
              id: 0,
              imageURL: nil,
              title: "")
    }
}
