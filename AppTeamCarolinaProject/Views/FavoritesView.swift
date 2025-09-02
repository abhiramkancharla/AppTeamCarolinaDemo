//
//  FavoritesView.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/1/25.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var favorites: FavoritesModel
    @EnvironmentObject var exhibitions: ExhibitionsModel
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if (favorites.data.isEmpty) {
                    findFavorites
                } else {
                    showFavorites
                }
            }
            .searchable(text: $searchText, prompt: "Search for an artwork")
            .navigationTitle("Favorites")
        }
    }
    
    @ViewBuilder
    var showFavorites: some View {
        ScrollView {
            VStack {
                ForEach(favorites.data) { artwork in
                    ArtworkView(thumbnail: URL(string: artwork.primaryimageurl) ?? URL(string: "https://nrs.harvard.edu/urn-3:HUAM:GS07977")!, artist: artwork.artist, dates: artwork.date ?? "", title: artwork.title, desc: artwork.description)
                        .environmentObject(favorites)
                }
            }
        }
    }
    
    @ViewBuilder
    var findFavorites: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("You have no favorited artworks.")
                .font(.title2)
                .foregroundStyle(.gray)
                .padding(7)
            
            NavigationLink {
                BrowseView()
                    .environmentObject(exhibitions)
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.blue)
                        .ignoresSafeArea()
                    Text("Browse Art")
                        .foregroundStyle(.white)
                        .bold()
                        .zIndex(1)
                }
            }
            .frame(width: 200, height: 50)
            .cornerRadius(10)
            Spacer()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesModel())
        .environmentObject(ExhibitionsModel())
}
