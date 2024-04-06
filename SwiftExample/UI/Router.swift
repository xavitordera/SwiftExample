import SwiftUI

final class Router: ObservableObject {
    
    enum Route: Equatable {
        case splash
        case login
        case articleList
        case articleDetail(id: Int)
    }

    private var authRepository: AuthRepositoryProtocol
    @Published private(set) var currentRoute: Route = .splash {
        didSet {
            if case .login = currentRoute {
                stack.removeAll()
            }
        }
    }
    private(set) var stack: [Route] = []

    init(authRepository: AuthRepositoryProtocol = AppEnvironment.current.authRepository) {

        self.authRepository = authRepository

        #if targetEnvironment(simulator)
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            self.authRepository = AuthRepositoryMock()
        }
        #endif

    }

    private func manageFirstRoute() async {
        let isValid = await authRepository.isTokenValid()
        DispatchQueue.main.async {
            let route = if isValid {
                Route.articleList
            } else {
                Route.login
            }
            self.currentRoute = route
            self.stack.append(route)
        }
    }

    func navigate(to route: Route) {
        withAnimation {
            currentRoute = route
            stack.append(route)
        }
    }

    func pop() {
        withAnimation {
            stack.removeLast()
            currentRoute = stack.last ?? .login
        }
    }

    @MainActor @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .login:
            let viewModel = LoginViewModel(repository: AppEnvironment.live.authRepository)
            LoginView(viewModel: viewModel, router: self)
        case .articleList:
            let viewModel = ArticleListViewModel(articlesRepository: ArticlesRepository(apiClient: APIClient(), keyChainClient: KeychainClient()), authRepository: AppEnvironment.live.authRepository)
            ArticleListView(viewModel: viewModel, router: self)
        case .articleDetail(let id):
            let viewModel = ArticleDetailViewModel(articleId: id)
            ArticleDetailView(viewModel: viewModel, router: self)
        case .splash:
            ProgressView()
                .onAppear { [weak self] in
                    Task {
                        await self?.manageFirstRoute()
                    }
                }
        }
    }
}
