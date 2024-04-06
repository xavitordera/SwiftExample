import SwiftUI

extension Components {
    struct AsyncImage: View {
        let url: URL?

        var body: some View {
            SwiftUI.AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 75)
            }
        }
    }
}
