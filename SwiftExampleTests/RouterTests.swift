import XCTest
@testable import SwiftExample
import SwiftUI

class RouterTests: XCTestCase {

    var router: Router!

    override func setUp() {
        super.setUp()
        router = Router(authRepository: AuthRepositoryMock())
    }

    override func tearDown() {
        router = nil
        super.tearDown()
    }

    func testInitialRouteIsSplash() {
        XCTAssertEqual(router.currentRoute, .splash)
    }

    func testNavigateToLogin() {
        router.navigate(to: .login)
        XCTAssertEqual(router.currentRoute, .login)
    }

    func testNavigateToArticleList() {
        router.navigate(to: .articleList)
        XCTAssertEqual(router.currentRoute, .articleList)
    }

    func testNavigateToArticleDetail() {
        let articleId = 123
        router.navigate(to: .articleDetail(id: articleId))
        XCTAssertEqual(router.currentRoute, .articleDetail(id: articleId))
    }

    func testPop() {
        router.navigate(to: .login)
        router.navigate(to: .articleList)
        router.pop()
        XCTAssertEqual(router.currentRoute, .login)
    }
}
