import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        // Main container for the application
        ZStack {
            // Show different views based on selected tab
            Group {
                if selectedTab == 0 {
                    HomeView(selectedTab: $selectedTab)
                } else if selectedTab == 1 {
                    // You can create other views for these tabs later
                    Text("Apple TV+")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                } else if selectedTab == 2 {
                    Text("Store")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                } else if selectedTab == 3 {
                    Text("Library")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                } else {
                    Text("Search")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
