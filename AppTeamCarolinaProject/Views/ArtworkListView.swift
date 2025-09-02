//
//  ArtworkView.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/1/25.
//

import SwiftUI

struct ArtworkListView: View {
    
    let exhibition: Exhibition
    
    @EnvironmentObject var favorites: FavoritesModel
    
    @State private var searchText = ""
    @State private var artworks: [Artwork] = []

    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {

                Spacer()
                ScrollView {
                    HStack {
                        Text(exhibition.title)
                            .font(.title)
                            .lineLimit(2)
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Text(exhibition.description ?? "")
                            .foregroundStyle(.gray)
                            .lineLimit(3)
                            .padding(1)
                        Spacer()
                    }
                    VStack {
                        ForEach(artworks) { artwork in
                            ArtworkView(thumbnail: URL(string: exhibition.primaryimageurl ?? "https://nrs.harvard.edu/urn-3:HUAM:GS07977") ?? URL(string: "https://nrs.harvard.edu/urn-3:HUAM:GS07977")!, artist: "", dates: artwork.date ?? "Unknown", title: artwork.title, desc: "")
                                .environmentObject(favorites)
                        }
                    }
                }
                .task {
                    artworks = await UtilModel.fetchArtworks(for: 4753)
                    print(artworks)
                }
            }
            .searchable(text: $searchText)
            .padding()
        }
    }
}

#Preview {
    ArtworkListView(exhibition: Exhibition(id: 4753, title: "Cannot Fetch", enddate: "", begindate: "", description: "", primaryimageurl: ""))
        .environmentObject(FavoritesModel())
}
