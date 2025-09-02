//
//  ArtworkView.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/1/25.
//

import SwiftUI

struct ArtworkView: View {
    
    @EnvironmentObject var favorites: FavoritesModel
        
    var thumbnail: URL
    var artist: String
    var dates: String
    var title: String
    var desc: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.clear)
            
            HStack {
                ZStack {
                    AsyncImage(url: thumbnail) { image in
                        image
                            .image?.resizable()
                            .frame(width: 200, height: 125)
                            .cornerRadius(10)
                    }
                    LoveButton(art: Artwork(id: 0, date: dates, title: title, artist: artist, description: desc, primaryimageurl: thumbnail.absoluteString))
                        .frame(width: 35, height: 35)
                        .padding()
                        .offset(x: 65, y: -25)
                }
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title3)
                        .lineLimit(1)
                        .bold()
                    Text("\(artist) \(dates)")
                    Text(desc)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
            .offset(x: -10)
        }
    }
}

#Preview {
    ArtworkView(thumbnail: URL(string: "https://nrs.harvard.edu/urn-3:HUAM:GS07977")!, artist: "Van Gogh", dates: "1800", title: "Starry Night", desc: "")
        .environmentObject(FavoritesModel())
}
