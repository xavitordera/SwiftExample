import SwiftUI
@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = "code"
    @Published var password: String = "test"
    @Published private(set) var state: State = .idle {
        didSet {
            if case .error(let error) = state {
                self.error = error
            }
        }
    }
    @Published var error: APIError? = nil

    let imageURL = APIURL.baseURL.appending(path: "/images/ipad.jpg")
    private let repository: AuthRepositoryProtocol

    enum State {
        case idle
        case loading
        case requestSent
        case error(APIError)

        var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }
    }

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func login(onSuccess: @escaping () -> ()) async {
        state = .loading
        
        do {
            _ = try await repository.login(username: username, password: password)
            state = .requestSent
            onSuccess()
        } catch let error as APIError {
            state = .error(error)
        } catch _ {
            state = .error(.noData)
        }
    }
}
