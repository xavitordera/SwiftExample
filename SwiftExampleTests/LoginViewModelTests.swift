import XCTest
@testable import SwiftExample

final class LoginViewModelTests: XCTestCase {

    private var systemUnderTest: LoginViewModel!
    private var authRepository: AuthRepositoryMock!

    @MainActor override func setUp() {
        super.setUp()
        authRepository = AuthRepositoryMock()
        systemUnderTest = LoginViewModel(repository: authRepository)
    }

    override func tearDown() {
        systemUnderTest = nil
        authRepository = nil
        super.tearDown()
    }

    func test_login_whenLoginSucceeds_shouldChangeStateToRequestSent() async {
        // given
        authRepository.loginResult = .success(())
        let onSuccessExpectation = expectation(description: "onSuccess")

        // when
        await systemUnderTest.login { onSuccessExpectation.fulfill() }

        // then
        await waitForExpectations(timeout: 0.1)

        if case .requestSent = await systemUnderTest.state {
            XCTAssert(true)
        } else {
            XCTFail()
        }
    }

    @MainActor func test_login_whenLoginFails_shouldChangeStateToError() async {
        // given
        authRepository.loginResult = .failure(.generic(""))
        
        // when

        let expectation = self.expectation(description: "onError")

        let cancellable = systemUnderTest.$state.sink { state in
            if case .error = state {
                expectation.fulfill()
            }
        }

        await systemUnderTest.login() { }

        // then
        await waitForExpectations(timeout: 0.1)
    }
}
