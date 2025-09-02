//
//  FavoritesModel.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/1/25.
//

import Foundation

class FavoritesModel: ObservableObject {
    @Published var data: [Artwork] = []
    
    func add(_ art: Artwork) -> Bool {
        if !data.contains(where: { $0.title == art.title }) {
            data.append(art)
            return true
        } else {
            remove(art)
            return false
        }
    }
    
    func remove(_ art: Artwork) {
        data.removeAll { $0.title == art.title }
    }
    
}
