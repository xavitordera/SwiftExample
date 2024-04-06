import SwiftUI

struct ArticleListView: View {
    @ObservedObject var viewModel: ArticleListViewModel
    @ObservedObject var router: Router

    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading, .idle, .error:
                ProgressView()
            case .loaded(let articles):
                content(articles: articles)
            }
        }
        .navigationTitle("Articles")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") {
                    viewModel.logout()
                    router.navigate(to: .login)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchArticles()
            }
        }
    }
        @ViewBuilder
    func content(articles: [ArticleUIModel]) -> some View {
        List(articles) { article in
            ArticleRowView(article: article) {
                router.navigate(to: .articleDetail(id: article.id))
            }
        }.errorAlert(error: $viewModel.error) { error in
            switch error {
            case .forbidden, .unauthorized:
                router.navigate(to: .login)
            default: break
            }
        }
    }
}

struct ArticleRowView: View {
    let article: ArticleUIModel
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center, spacing: Components.Space.medium) {
                Components.AsyncImage(url: article.thumbnailURL)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: Components.Space.small) {
                    Text(article.title)
                        .font(.headline)
                    Text(article.summary)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(Components.Space.medium)
            }
        }
    }
}

#Preview {
    let mockURL = URL(string: "https://httpducks.com/405.jpg")!
    let _ = [ArticleUIModel(title: "Title", summary: "Summary", thumbnailURL: mockURL, date: "Date", id: 0),
                    ArticleUIModel(title: "Title", summary: "Summary", thumbnailURL: mockURL, date: "Date", id: 1),
                    ArticleUIModel(title: "Title", summary: "Summary", thumbnailURL: mockURL, date: "Date", id: 2)]
    let viewModel = ArticleListViewModel(articlesRepository: ArticleRepositoryMock(), authRepository: AuthRepositoryMock())

    return ArticleListView(viewModel: viewModel, router: Router())
}

struct ArticleRepositoryMock: ArticlesRepositoryProtocol {
    func fetchArticles() async throws -> [ArticleUIModel] {
        fatalError()
    }
    
    func fetchArticleDetails(id: Int) async throws -> ArticleDetailUIModel {
        fatalError()
    }
    
    let mockURL = URL(string: "https://httpducks.com/405.jpg")!

    func fetchArticles(completion: @escaping (Result<[ArticleUIModel], APIError>) -> Void) {
        completion(.success( [ArticleUIModel(title: "Title", summary: "Summary", thumbnailURL: mockURL, date: "Date", id: 0),
                              ArticleUIModel(title: "Title", summary: "Summary", thumbnailURL: mockURL, date: "Date", id: 1),
                              ArticleUIModel(title: "Title", summary: "Summary", thumbnailURL: mockURL, date: "Date", id: 2)]))
    }
    
    func fetchArticleDetails(id: Int, completion: @escaping (Result<ArticleDetailUIModel, APIError>) -> Void) {
        completion(.success(
            .init(content: "Content", date: "Date", id: 1, imageURL: mockURL, title: "Title")
        ))
    }
}
