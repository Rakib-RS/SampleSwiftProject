import SwiftUI

struct ContentView: View {
    @State private var isNavigating = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, SwiftUI!")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: OtherView(), isActive: $isNavigating) {
                    EmptyView()
                }
                .opacity(0) // Make the NavigationLink invisible

                Button("Navigate to Other View") {
                    // Action to perform when the button is tapped
                    print("Button tapped!")

                    // Set isNavigating to true to trigger navigation
                    isNavigating = true
                }
                .font(.headline)
                .padding()
            }
        }
        // Use StackNavigationViewStyle to hide the back button
    }
}

struct OtherView: View {
    var body: some View {
        Text("This is the other view")
            .font(.largeTitle)
            .padding()
    }
}


