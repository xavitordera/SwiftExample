import SwiftUI

struct ArticleDetailView: View {
    @ObservedObject var viewModel: ArticleDetailViewModel
    @ObservedObject var router: Router

    var body: some View {
        content
            .onAppear {
                Task {
                    await viewModel.fetchArticle()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        router.pop()
                    }
                }
            }
            .errorAlert(error: $viewModel.error)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading, .idle, .error:
            ProgressView()
        case .loaded(let article):
            ArticleDetailContentView(article: article)
        }
    }
}

struct ArticleDetailContentView: View {
    let article: ArticleDetailUIModel
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Components.Space.medium) {
                    Components.AsyncImage(url: article.imageURL)
                        .frame(maxWidth: .infinity)
                    VStack(alignment: .leading, spacing: Components.Space.medium) {
                        Text(article.title)
                            .font(.title)
                        Text("Medium - \(article.date)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(article.content)
                            .font(.body)
                    }
                    .padding(.horizontal, Components.Space.medium)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    let viewModel = ArticleDetailViewModel(articleId: 1, articleRepository: ArticleRepositoryMock())
    return ArticleDetailView(viewModel: viewModel, router: Router())
}
