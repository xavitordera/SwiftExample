import XCTest
@testable import SwiftExample

final class LoginViewModelTests: XCTestCase {

    private var systemUnderTest: LoginViewModel!
    private var authRepository: AuthRepositoryMock!

    override func setUp() {
        super.setUp()
        authRepository = AuthRepositoryMock()
        systemUnderTest = LoginViewModel(repository: authRepository)
    }

    override func tearDown() {
        systemUnderTest = nil
        authRepository = nil
        super.tearDown()
    }


//    func login(onSuccess: @escaping () -> ()) {
//        state = .loading
//        repository.login(username: username, password: password) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    self?.state = .requestSent
//                    onSuccess()
//                case .failure(let error):
//                    self?.state = .error(error)
//                }
//            }
//        }
//    }

    func test_login_whenLoginSucceeds_shouldChangeStateToRequestSent() {
        // given
        authRepository.loginResult = .success(.init(accessToken: "", refreshToken: ""))
        let onSuccessExpectation = expectation(description: "onSuccess")

        // when
        systemUnderTest.login { onSuccessExpectation.fulfill() }

        // then
        waitForExpectations(timeout: 0.1)

        if case .requestSent = systemUnderTest.state {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }

    func test_login_whenLoginFails_shouldChangeStateToError() {
        // given
        authRepository.loginResult = .failure(.generic(""))
        
        // when

        let expectation = self.expectation(description: "onError")

        let cancellable = systemUnderTest.$state.sink { state in
            if case .error = state {
                expectation.fulfill()
            }
        }

        systemUnderTest.login {  }

        // then
        waitForExpectations(timeout: 0.1)
    }
}
