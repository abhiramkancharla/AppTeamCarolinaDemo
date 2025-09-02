//
//  LoveButton.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/2/25.
//

import SwiftUI

struct LoveButton: View {
    
    @EnvironmentObject var favorites: FavoritesModel
    @State private var isHearted: Bool = false
    
    var art: Artwork
    
    var body: some View {
        
        Button() {
            isHearted = favorites.add(art)
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(.white)
                Image(systemName: isHearted ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 20, height: 17)
                    .foregroundStyle(.pink)
            }
        }
        
    }
}

#Preview {
    LoveButton(art: Artwork(id: 0, date: "", title: "", artist: "", description: "", primaryimageurl: ""))
        .environmentObject(FavoritesModel())
}
