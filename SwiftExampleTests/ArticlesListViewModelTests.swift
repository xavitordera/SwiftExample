import XCTest
@testable import SwiftExample
import Combine

final class ArticlesListViewModelTests: XCTestCase {

    private var systemUnderTest: ArticleListViewModel!
    private var articlesRepository: ArticlesRepositoryMock!
    private var authRepository: AuthRepositoryMock!
    private var disposeBag: Set<AnyCancellable>! = []

    @MainActor override func setUp() {
        super.setUp()
        articlesRepository = ArticlesRepositoryMock()

        authRepository = AuthRepositoryMock()
        systemUnderTest = ArticleListViewModel(articlesRepository: articlesRepository, authRepository: authRepository)
        disposeBag = []
    }

    override func tearDown() {
        systemUnderTest = nil
        articlesRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    @MainActor func test_fetchArticles_whenRequestSucceeds_shouldReturnArticles() async {
        // given
        let articles = [ArticleUIModel.mock]
        articlesRepository.fetchArticlesResult = .success(articles)

        // when
        let exp = expectation(description: "Waiting for fetchArticles to complete")

        systemUnderTest.$state.sink { state in
            if case .loaded = state {
                exp.fulfill()
            }
        }.store(in: &disposeBag)

        await systemUnderTest.fetchArticles()

        // then
        waitForExpectations(timeout: 0.1)
    }

    @MainActor func test_fetchArticles_whenRequestFails_shouldReturnError() async {
        // given
        articlesRepository.fetchArticlesResult = .failure(.generic(""))

        // when

        let exp = expectation(description: "Waiting for fetchArticles to complete")
        systemUnderTest.$state.sink { state in
            if case .error = state {
                exp.fulfill()
            }
        }.store(in: &disposeBag)

        await systemUnderTest.fetchArticles()

        // then
        waitForExpectations(timeout: 0.1)
    }

    @MainActor func test_logout_callsRepository() {
        // when
        systemUnderTest.logout()

        // then
        XCTAssertTrue(authRepository.logoutCalled)
    }
}
