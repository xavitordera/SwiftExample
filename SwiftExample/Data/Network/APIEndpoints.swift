import Foundation

enum APIURL {
    static let ef = "f"
    static let doubleu = "w"
    static let es = "s"
    static let mobile = "mobile"
    static let code = "code"
    static let test = "test"
    static let baseURL = if let url = URL(string: "https://\(mobile)\(code)\(test).\(ef)\(doubleu)\(es).io") {
        url
    } else { fatalError("Base URL can't be constructed") }
}

enum APIEndpoint {
    case authentication(AuthenticationEndpoint)
    case articles(ArticlesEndpoint)

    private var isProtected: Bool {
        switch self {
        case .authentication:
            return false
        case .articles:
            return true
        }
    }

    func urlRequest(keyChainClient: KeychainClientProtocol = KeychainClient()) -> URLRequest {
        var request = URLRequest(url: APIURL.baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = {
            if isProtected,
                let token = keyChainClient.requestAccessToken() {
                headers
                    .merging(["Authorization": "Bearer \(token)"]) { _, new in new }
            } else {
                headers
            }
        }()
        request.httpBody = if let parameters {
            try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } else { nil }
        return request
    }

    var path: String {
        switch self {
        case .authentication(let endpoint):
            "/auth/\(endpoint.path)"
        case .articles(let endpoint):
            "/api/v1/articles\(endpoint.path)"
        }
    }

    var method: HttpMethod {
        switch self {
        case .authentication(let endpoint):
            endpoint.method
        case .articles(let endpoint):
            endpoint.method
        }
    }

    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }

    var parameters: [String: Any]? {
        switch self {
        case .authentication(let endpoint):
            endpoint.parameters
        case .articles(let endpoint):
            endpoint.parameters
        }
    }
}

// Enum representing HTTP methods
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// Enum representing authentication endpoints
enum AuthenticationEndpoint {
    case getToken(username: String, password: String)
    case refreshToken(String)

    var path: String {
        switch self {
        case .getToken, .refreshToken:
            "token"
        }
    }

    var method: HttpMethod {
        .post
    }

    var parameters: [String: Any]? {
        switch self {
        case .getToken(let username, let password):
            [
                "username": username,
                "password": password,
                "grant_type": "password"
            ]
        case .refreshToken(let refreshToken):
            [
                "refresh_token": refreshToken,
                "grant_type": "refresh_token"
            ]
        }
    }
}

// Enum representing articles endpoints
enum ArticlesEndpoint {
    case getAll
    case getDetail(articleId: Int)

    var path: String {
        switch self {
        case .getAll:
            ""
        case .getDetail(let articleId):
            "/\(articleId)"
        }
    }

    var method: HttpMethod {
        switch self {
        case .getAll:
            .get
        case .getDetail:
            .get
        }
    }

    var parameters: [String: Any]? {
        nil
    }
}
