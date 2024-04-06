import SwiftUI

extension Components {
    struct Button: View {
        let title: String
        let action: () -> ()
        private var isLoading: Bool = false

        init(title: String, action: @escaping () -> ()) {
            self.title = title
            self.action = action
        }

        var body: some View {
            SwiftUI.Button {
                action()
            } label: {
                if isLoading {
                    ProgressView()
                        .foregroundColor(.white)
                } else {
                    Text(title)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(Space.small)
            .fixedSize()
        }

        func isLoading(_ isLoading: Bool) -> Button {
            var button = self
            button.isLoading = isLoading
            return button
        }
    }
}
