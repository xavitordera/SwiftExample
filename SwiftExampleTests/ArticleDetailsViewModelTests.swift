import XCTest
import Combine
@testable import SwiftExample

final class ArticleDetailsViewModelTests: XCTestCase {

    private var systemUnderTest: ArticleDetailViewModel!
    private var articlesRepository: ArticlesRepositoryMock!
    private var disposeBag: Set<AnyCancellable>! = []

    @MainActor override func setUp() {
        super.setUp()
        articlesRepository = ArticlesRepositoryMock()
        systemUnderTest = ArticleDetailViewModel(articleId: 1, articleRepository: articlesRepository)
    }

    override func tearDown() {
        systemUnderTest = nil
        articlesRepository = nil
        disposeBag = []
        super.tearDown()
    }

    @MainActor func test_fetchArticleDetails_whenRequestSucceeds_shouldReturnArticleDetails() async {
        // given
        let article = ArticleDetailUIModel.mock
        articlesRepository.fetchArticleDetailsResult = .success(article)

        // when
        let exp = expectation(description: "Waiting for fetchArticle to complete")

        systemUnderTest.$state.sink { state in
            if case .loaded = state {
                exp.fulfill()
            }
        }.store(in: &disposeBag)
        // then

        await systemUnderTest.fetchArticle()

        await fulfillment(of: [exp])
    }

    func test_fetchArticleDetails_whenRequestFails_shouldReturnError() async {
        // given
        articlesRepository.fetchArticleDetailsResult = .failure(.generic(""))

        let exp = expectation(description: "Waiting for fetchArticle to complete")

        await systemUnderTest.$state.sink { state in
            if case .error = state {
                exp.fulfill()
            }
        }.store(in: &disposeBag)

        // when
        await systemUnderTest.fetchArticle()

        // then
        await fulfillment(of: [exp])
    }
}
