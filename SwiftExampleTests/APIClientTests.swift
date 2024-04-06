@testable import SwiftExample
import XCTest
import Foundation

final class APIClientTests: XCTestCase {
    private var apiClient: APIClient!
    private var urlSession: URLSessionMock!
    private var decoder: DecoderMock!
    
    override func setUp() {
        super.setUp()
        urlSession = URLSessionMock()
        decoder = DecoderMock()
        apiClient = APIClient(urlSession: urlSession, decoder: decoder)
    }
    
    override func tearDown() {
        apiClient = nil
        decoder = nil
        urlSession = nil
        super.tearDown()
    }
    
    func test_request_whenRequestFails_shouldReturnError() async {
        // given
        let request = URLRequest(url: URL(string: "http://test.com")!)
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        urlSession.error = error

        struct Helper: Decodable {}

        // when
        do {
            let _ : Helper = try await apiClient.request(request: request)
            XCTFail()
        } catch _ {
            XCTAssert(true)
        }
        
        // then
    }
    
    func test_request_whenRequestSucceeds_shouldReturnDecodedObject() async throws {
        // given
        let request = URLRequest(url: URL(string: "http://test.com")!)
        let data = Data("""
            {
                "title": "title",
                "description": "description"
            }
            """.utf8)
        let object = ArticleDataModel.mock
        urlSession.data = data
        urlSession.response = HTTPURLResponse()
        decoder.decodeResult = .success(object)

        // when
        let result: ArticleDataModel = try await apiClient.request(request: request)

        // then
        XCTAssertEqual(result, object)
    }
}
