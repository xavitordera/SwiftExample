import SwiftUI

extension View {
    func errorAlert(error: Binding<APIError?>, buttonTitle: String = "OK", errorAction: @escaping (APIError?) -> Void = { _ in }) -> some View {
        let localizedAlertError = LocalizedAlertError(underlyingError: error.wrappedValue)

        return alert(localizedAlertError.errorDescription ?? "", isPresented: .constant(error.wrappedValue != nil)) {
            Button(buttonTitle) {
                errorAction(error.wrappedValue)
                error.wrappedValue = nil
            }
        } message: {
            Text(localizedAlertError.errorDescription ?? "")
        }
    }

    func onLoad(perform action: @escaping () -> Void) -> some View {
        var isLoaded = false
        return self.onAppear {
            if !isLoaded {
                action()
            }
            isLoaded = true
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: APIError?
    var recoverySuggestion: String? { "Please try again" }
    var errorDescription: String? {
        switch underlyingError {
        case .noData:
            "No data available"
        case .decodingError(let string):
            "Decoding error: \(string)"
        case .generic(let string):
            "Generic error: \(string)"
        case .unknown(let error):
            "Unknown error: \(error.localizedDescription)"
        case .forbidden:
            "Incorrect username or password"
        case .none:
            nil
        case .unauthorized:
            "Please log in again"
        }
    }
}
