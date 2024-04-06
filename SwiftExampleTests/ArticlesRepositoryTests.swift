import XCTest
@testable import SwiftExample

final class ArticlesRepositoryTests: XCTestCase {
    private var systemUnderTest: ArticlesRepository!
    private var apiClient: APIClientMock!

    override func setUp() {
        super.setUp()
        apiClient = APIClientMock()
        systemUnderTest = ArticlesRepository(apiClient: apiClient)
    }

    override func tearDown() {
        systemUnderTest = nil
        apiClient = nil
        super.tearDown()
    }

    func test_fetchArticles_whenRequestSucceeds_shouldReturnArticles() {
        // given
        let articles = [ArticleDataModel.mock]
        apiClient.result = .success(articles)

        // when
        var result: Result<[ArticleUIModel], APIError>?
        systemUnderTest.fetchArticles { response in
            result = response
        }

        // then
        if case .success(let articles) = result {
            XCTAssertEqual(articles, articles)
        } else {
            XCTFail()
        }
    }

    func test_fetchArticles_whenRequestFails_shouldReturnError() {
        // given
        apiClient.result = .failure(.generic(""))

        // when
        var result: Result<[ArticleUIModel], APIError>?
        systemUnderTest.fetchArticles { response in
            result = response
        }

        // then
        if case .failure = result {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }

    func test_fetchArticleDetails_whenRequestSucceeds_shouldReturnArticleDetails() {
        // given
        let article = ArticleDetailsDataModel.mock
        apiClient.result = .success(article)

        // when
        var result: Result<ArticleDetailUIModel, APIError>?
        systemUnderTest.fetchArticleDetails(id: 1) { response in
            result = response
        }

        // then
        if case .success(let article) = result {
            XCTAssertEqual(article, article)
        } else {
            XCTFail()
        }
    }

    func test_fetchArticleDetails_whenRequestFails_shouldReturnError() {
        // given
        apiClient.result = .failure(.generic(""))

        // when
        var result: Result<ArticleDetailUIModel, APIError>?
        systemUnderTest.fetchArticleDetails(id: 1) { response in
            result = response
        }

        // then
        if case .failure = result {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }
}
