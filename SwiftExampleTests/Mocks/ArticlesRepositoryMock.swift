@testable import SwiftExample
import Foundation

final class ArticlesRepositoryMock: ArticlesRepositoryProtocol {
    var fetchArticlesResult: Result<[ArticleUIModel], APIError> = .success([.mock])
    var fetchArticleDetailsResult: Result<ArticleDetailUIModel, APIError> = .success(.mock)
    
    func fetchArticles() async throws -> [SwiftExample.ArticleUIModel] {
        switch fetchArticlesResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func fetchArticleDetails(id: Int) async throws -> SwiftExample.ArticleDetailUIModel {
        switch fetchArticleDetailsResult {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}

extension ArticleUIModel {
    static var mock: ArticleUIModel {
        .init(title: "title",
              summary: "summary",
              thumbnailURL: URL(string: "thumbnailUrl"),
              date: "date",
              id: 1)
    }
}

extension ArticleDetailUIModel {
    static var mock: ArticleDetailUIModel {
        .init(content: "content",
              date: "date",
              id: 1,
              imageURL: URL(string: "imageUrl"),
              title: "title")
    }
}
