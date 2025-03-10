import SwiftUI

// Episode Card Component
struct EpisodeCard: View {
    let episodeNumber: Int
    let title: String
    let description: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            // Episode Image - fixed height ensures alignment
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 280, height: 160)
                .cornerRadius(8)
                .clipped()
            
            // Fixed height content area for consistent card sizes
            VStack(alignment: .leading, spacing: 8) {
                Text("EPISODE \(episodeNumber)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .frame(height: 50, alignment: .top) // Fixed height for description area
            }
            .frame(width: 280)
        }
        .frame(width: 280, height: 260) // Fixed overall card height for consistency
    }
}

// Bonus Content Card Component
struct BonusContentCard: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            // Bonus Content Image - fixed height ensures alignment
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 280, height: 160)
                .cornerRadius(8)
                .clipped()
            
            // Fixed height area for title
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
                .frame(width: 280, height: 50, alignment: .topLeading) // Fixed height for title area
        }
        .frame(width: 280, height: 220) // Fixed overall card height for consistency
    }
}

// Cast & Crew Profile Component
struct CastCrewProfile: View {
    let name: String
    let role: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .center) {
            // Circular profile image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 90, height: 90)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            
            Text(name)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 100)
            
            Text(role)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 100)
        }
        .frame(width: 100, height: 160) // Fixed height for consistency
    }
}
