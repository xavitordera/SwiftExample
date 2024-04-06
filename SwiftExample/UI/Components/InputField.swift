import SwiftUI

extension Components {
    struct InputField: View {

        enum Kind {
            case username
            case password
        }

        let placeholder: String
        let inputType: Kind
        let text: Binding<String>

        @ViewBuilder
        fileprivate var input: some View {
            switch inputType {
            case .username:
                TextField(placeholder, text: text)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            case .password:
                SecureField(placeholder, text: text)
            }
        }

        var body: some View {
            input
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(Space.small)
                .padding(.horizontal, Space.large)
        }
    }

}
