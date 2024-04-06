import Foundation

protocol ArticlesRepositoryProtocol {
    func fetchArticles() async throws -> [ArticleUIModel]
    func fetchArticleDetails(id: Int) async throws -> ArticleDetailUIModel
}

struct ArticlesRepository: ArticlesRepositoryProtocol {
    private let apiClient: APIClientProtocol
    private let keyChainClient: KeychainClientProtocol

    init(apiClient: APIClientProtocol = APIClient(),
         keyChainClient: KeychainClientProtocol = KeychainClient()) {
        self.apiClient = apiClient
        self.keyChainClient = keyChainClient
    }

    func fetchArticles() async throws -> [ArticleUIModel] {
        let articles: [ArticleDataModel] = try await apiClient.request(request: APIEndpoint.articles(.getAll).urlRequest())
        return articles.map { ArticleUIModel($0) }
    }
    
    func fetchArticleDetails(id: Int) async throws -> ArticleDetailUIModel {
        let article: ArticleDetailsDataModel = try await apiClient.request(request: APIEndpoint.articles(.getDetail(articleId: id)).urlRequest())
        return ArticleDetailUIModel(article)
    }
}
