//
//  ArtworksModel.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/2/25.
//

import Foundation

struct Artwork: Decodable, Identifiable {
    let id: Int
    let date: String?
    let title: String
    let artist: String
    let description: String
    let primaryimageurl: String
    
}

@MainActor
class ArtworksModel: ObservableObject {
    
    @Published var data: [Artwork] = []
    
    func load() async {
        let artworks = await UtilModel.fetchArtworks(for: 0)
        Task { @MainActor in
            data = artworks
        }
    }
}
