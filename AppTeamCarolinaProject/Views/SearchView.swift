//
//  SearchView.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/1/25.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .searchable(text: $searchText, prompt: "Search for an artwork")
        }
    }
}

#Preview {
    SearchView()
}
