//
//  ArtworkView.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/1/25.
//

import SwiftUI

struct ArtworkListView: View {
    
    @State private var searchText = ""
    
    let exhibition: Exhibition
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Van Gogh Exhibition: The Immersive Experience")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                HStack {
                    Text("This exhibition is a fully immersive room with a 360 digital show. 60 projectors bring 200 Van Gogh's masterpieces to life on a 1000 m2 surface")
                        .foregroundStyle(.gray)
                        .padding(1)
                    Spacer()
                }
                Spacer()
            }
            .searchable(text: $searchText)
            .padding()
        }
    }
}

#Preview {
    ArtworkView(exhibition: Exhibition(id: 0, title: "Cannot Fetch", enddate: "", begindate: "", description: "", primaryimageurl: ""))
}
