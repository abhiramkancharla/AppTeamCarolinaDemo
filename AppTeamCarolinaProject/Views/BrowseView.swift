//
//  BrowseView.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 8/30/25.
//

import SwiftUI

struct ExhibitionResponse: Codable {
    let records: [Exhibition]
}

struct BrowseView: View {
         
    @State private var searchText = ""
    //@State private var exhibitions: [Exhibition] = []
    
    @EnvironmentObject var exhibitions: ExhibitionsModel
    @EnvironmentObject var favorites: FavoritesModel
    
    var filteredExhibitions: [Exhibition] {
        if searchText.isEmpty {
            return exhibitions.data
        } else {
            return exhibitions.data.filter { exhibition in
                exhibition.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(filteredExhibitions) { exhibition in
                        NavigationLink(destination:
                                        ArtworkListView(exhibition: exhibition)
                            .environmentObject(favorites)
                        ) {
                            ExhibitionView(
                                thumbnail: URL(string: exhibition.primaryimageurl ?? "https://nrs.harvard.edu/urn-3:HUAM:GS07977") ?? URL(string: "https://nrs.harvard.edu/urn-3:HUAM:GS07977")!,
                                dates: "\(UtilModel.getTextDate(begin: exhibition.begindate ?? "", end: exhibition.enddate ?? ""))",
                                title: exhibition.title,
                                desc: exhibition.description ?? "No description")
                                .frame(width: 375, height: 325)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .navigationTitle("Browse")
        }
        .searchable(text: $searchText, prompt: "Search for an exhibition")
    }
    
}

#Preview {
    BrowseView()
        .environmentObject(ExhibitionsModel())
        .environmentObject(FavoritesModel())
}
