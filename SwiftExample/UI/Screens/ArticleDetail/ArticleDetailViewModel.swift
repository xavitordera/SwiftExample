import SwiftUI

@MainActor
final class ArticleDetailViewModel: ObservableObject {
    private let articleId: Int
    private let articleRepository: ArticlesRepositoryProtocol
    @Published var error: APIError?

    @Published var state: State = .idle {
        didSet {
            if case .error(let error) = state {
                self.error = error
            }
        }
    }

    enum State {
        case idle
        case loading
        case loaded(article: ArticleDetailUIModel)
        case error(APIError)

        var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }
    }

    init(articleId: Int,
         articleRepository: ArticlesRepositoryProtocol = ArticlesRepository()) {
        self.articleId = articleId
        self.articleRepository = articleRepository
    }

    func fetchArticle() async {
        state = .loading
        do {
            state = .loaded(
                article: try await articleRepository.fetchArticleDetails(id: articleId)
            )
        } catch let error as APIError {
            state = .error(error)
        } catch _ {
            state = .error(.noData)
        }
    }
}
