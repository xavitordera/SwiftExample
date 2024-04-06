import XCTest
import Combine
@testable import SwiftExample

final class ArticleDetailsViewModelTests: XCTestCase {

    private var systemUnderTest: ArticleDetailViewModel!
    private var articlesRepository: ArticlesRepositoryMock!
    private var disposeBag: Set<AnyCancellable>! = []

    override func setUp() {
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

    func test_fetchArticleDetails_whenRequestSucceeds_shouldReturnArticleDetails() {
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

        systemUnderTest.fetchArticle()

        waitForExpectations(timeout: 0.1)
    }

    func test_fetchArticleDetails_whenRequestFails_shouldReturnError() {
        // given
        articlesRepository.fetchArticleDetailsResult = .failure(.generic(""))

        let exp = expectation(description: "Waiting for fetchArticle to complete")

        systemUnderTest.$state.sink { state in
            if case .error = state {
                exp.fulfill()
            }
        }.store(in: &disposeBag)

        // when
        systemUnderTest.fetchArticle()

        // then
        waitForExpectations(timeout: 0.1)
    }
}
