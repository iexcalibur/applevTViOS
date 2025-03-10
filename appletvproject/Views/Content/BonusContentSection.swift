import SwiftUI

struct BonusContentSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Bonus Content")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, 40)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    // Import BonusContentCard from CardComponents.swift
                    BonusContentCard(
                        title: "Inside Amazing Earth: Cheetah Valleys",
                        imageName: "poster" // You can replace with actual images
                    )
                    
                    BonusContentCard(
                        title: "The Making of Bear Woods",
                        imageName: "poster" // You can replace with actual images
                    )
                    
                    BonusContentCard(
                        title: "Behind the Scenes: Bird Cities",
                        imageName: "poster" // You can replace with actual images
                    )
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(.vertical, 20)
    }
}

struct BonusContentSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            BonusContentSection()
        }
        .preferredColorScheme(.dark)
    }
}
