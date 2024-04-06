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

    func test_fetchArticles_whenRequestSucceeds_shouldReturnArticles() async throws {
        // given
        let articles = [ArticleDataModel.mock]
        apiClient.result = .success(articles)

        // when
        let articlesRes = try await systemUnderTest.fetchArticles()
        XCTAssertEqual([.mock], articlesRes)
    }

    func test_fetchArticles_whenRequestFails_shouldReturnError() async {
        // given
        apiClient.result = .failure(.generic(""))

        // then
        do {
            _ = try await systemUnderTest.fetchArticles()
            XCTFail()
        } catch _ {
            XCTAssert(true)
        }
    }

    func test_fetchArticleDetails_whenRequestSucceeds_shouldReturnArticleDetails() async throws {
        // given
        let article = ArticleDetailsDataModel.mock
        apiClient.result = .success(article)

        // when
        let articleRes = try await systemUnderTest.fetchArticleDetails(id: 1)

        // then
        XCTAssertEqual(.mock, articleRes)
    }

    func test_fetchArticleDetails_whenRequestFails_shouldReturnError() async {
        // given
        apiClient.result = .failure(.generic(""))

        // when
        do {
            let _ = try await systemUnderTest.fetchArticleDetails(id: 1)
            XCTFail()
        } catch _ {
            XCTAssert(true)
        }
    }
}
