import SwiftUI
@MainActor
final class ArticleListViewModel: ObservableObject {
    @Published var error: APIError? = nil
    var loaded = false

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
        case loaded([ArticleUIModel])
        case error(APIError)
    }

    private let articlesRepository: ArticlesRepositoryProtocol
    private let authRepository: AuthRepositoryProtocol

    init(articlesRepository: ArticlesRepositoryProtocol,
         authRepository: AuthRepositoryProtocol) {
        self.articlesRepository = articlesRepository
        self.authRepository = authRepository
    }

    func fetchArticles() async {
        state = .loading
        
        do {
            let articles = try await articlesRepository.fetchArticles()
            state = .loaded(articles)
        } catch let error as APIError {
            state = .error(error)
        } catch _ {
            state = .error(.noData)
        }
    }

    func logout() {
        authRepository.logout()
    }
}
