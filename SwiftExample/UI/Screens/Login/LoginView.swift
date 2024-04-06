import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var router: Router

    var body: some View {
        NavigationStack {
            content
                .errorAlert(error: $viewModel.error)
        }
    }

    var content: some View {
        VStack {
            Components.AsyncImage(url: viewModel.imageURL)

            VStack(spacing: Components.Space.medium) {
                VStack (alignment: .leading, spacing:Components.Space.medium) {
                    Components.InputField(placeholder: "Username", inputType: .username, text: $viewModel.username)
                    Components.InputField(placeholder: "Password", inputType: .password, text: $viewModel.password)
                }

                Components.Button(title: "Login") {
                    Task {
                        await viewModel.login {
                            router.navigate(to: .articleList)
                        }
                    }
                }
                .isLoading(viewModel.state.isLoading)

                Spacer()
            }
            .padding()
            .background(Color.white)
        }
    }
}


#Preview {
    LoginView(viewModel: .init(repository: AuthRepositoryMock()), router: Router())
}
