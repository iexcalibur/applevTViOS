import SwiftUI

struct SeasonSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Season 2")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.blue)
            }
            .padding(.leading, 40)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    // Episode 1
                    EpisodeCard(
                        episodeNumber: 1,
                        title: "Elephant Savannah",
                        description: "Discover incredible african savannah with great elephant families...",
                        imageName: "poster" // You can replace with actual images
                    )
                    
                    // Episode 2
                    EpisodeCard(
                        episodeNumber: 2,
                        title: "Ram Mountains",
                        description: "This is a beautiful country where proud and independent mountain rams live, which briskly jump from stone to stone.",
                        imageName: "poster" // You can replace with actual images
                    )
                    
                    // Episode 3
                    EpisodeCard(
                        episodeNumber: 3,
                        title: "Kangaroo Plains",
                        description: "See how incredibly fast as the wind kangaroos rush through the endless valleys of Australia.",
                        imageName: "poster" // You can replace with actual images
                    )
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(.vertical, 20)
    }
}

struct SeasonSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            SeasonSection()
        }
        .preferredColorScheme(.dark)
    }
}

