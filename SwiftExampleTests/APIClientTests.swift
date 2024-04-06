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
    
    func test_request_whenRequestFails_shouldReturnError() {
        // given
        let request = URLRequest(url: URL(string: "http://test.com")!)
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        urlSession.error = error

        struct Helper: Decodable {}

        // when
        var result: Result<Helper, APIError>?
        apiClient.request(request: request) { (response: Result<Helper, APIError>) in
            result = response
        }
        
        // then
        if case .failure(.unknown(let errorReceived)) = result {
            XCTAssertEqual(errorReceived as NSError, error)
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }
    
    func test_request_whenRequestSucceeds_shouldReturnDecodedObject() {
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
        var result: Result<ArticleDataModel, APIError>?
        apiClient.request(request: request) { (response: Result<ArticleDataModel, APIError>) in
            result = response
        }
        let receivedObject: ArticleDataModel? = if case .success(let object) = result { object } else { nil }

        // then
        XCTAssertEqual(receivedObject, object)
    }
}
