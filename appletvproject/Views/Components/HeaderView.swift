import SwiftUI

struct HeaderView: View {
    // Add state for showing video player and alert
    @State private var showVideoPlayer = false
    // Remove alert state
    // @State private var showAlert = false 
    
    // Add focus state for the entire header view
    @FocusState private var viewFocused: Bool
    
    var body: some View {
        Button(action: {
            print("HeaderView tapped!")
            // Directly show video player without alert
            showVideoPlayer = true
        }) {
            ZStack(alignment: .bottomLeading) {
                // Image that stretches when pulled down
                GeometryReader { geometry in
                    Image("poster")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: max(0, geometry.frame(in: .global).minY + 700))
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                        .offset(y: -geometry.frame(in: .global).minY)
                }
                .frame(height: 700)
                
                // Content details - now part of the button's label
                DocumentaryDetailsView(isPartOfButton: true)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .focused($viewFocused)
        .onAppear {
            // Request focus on the view when it appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewFocused = true
            }
        }
        // Use fullScreenCover instead of sheet for full screen presentation
        .fullScreenCover(isPresented: $showVideoPlayer) {
            VideoPlayerView()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .preferredColorScheme(.dark)
    }
}
