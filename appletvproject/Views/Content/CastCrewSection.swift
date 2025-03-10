import SwiftUI

struct CastCrewSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Cast & Crew")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("See All")
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 40)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    // Cast & Crew profiles
                    CastCrewProfile(
                        name: "Simon Smith",
                        role: "Narrator",
                        imageName: "Avatar"
                    )
                    
                    CastCrewProfile(
                        name: "Dylan Adams",
                        role: "Executive Producer",
                        imageName: "Avatar"
                    )
                    
                    CastCrewProfile(
                        name: "Elizabeth Pointdexter",
                        role: "Executive Producer",
                        imageName: "Avatar"
                    )
                    
                    CastCrewProfile(
                        name: "Radjiv Singh",
                        role: "Scene Designer",
                        imageName: "Avatar"
                    )
                    
                    CastCrewProfile(
                        name: "Michael Jefferson",
                        role: "Author",
                        imageName: "Avatar"
                    )
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(.vertical, 40)
    }
}

struct CastCrewSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            CastCrewSection()
        }
        .preferredColorScheme(.dark)
    }
}

