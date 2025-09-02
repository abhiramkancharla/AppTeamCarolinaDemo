//
//  ContentView.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 8/30/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var artworks = ArtworksModel()
    @StateObject private var favorites = FavoritesModel()
    @StateObject private var exhibitions = ExhibitionsModel()
    
    var body: some View {
        TabView {
            BrowseView()
                .tabItem {
                    Image(systemName: "photo.artframe")
                    Text("Browse")
                }
                .environmentObject(artworks)
                .environmentObject(favorites)
                .environmentObject(exhibitions)
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .environmentObject(favorites)
                .environmentObject(exhibitions)
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .environmentObject(artworks)
                .environmentObject(exhibitions)
        }
        .task {
            await exhibitions.load()
            await artworks.load()
        }
    }
}

#Preview {
    ContentView()
}
