import SwiftUI

struct ContentView: View {
    @StateObject private var router: Router = Router()

    var body: some View {
        NavigationStack {
            router.view(for: router.currentRoute)
        }
    }
}
