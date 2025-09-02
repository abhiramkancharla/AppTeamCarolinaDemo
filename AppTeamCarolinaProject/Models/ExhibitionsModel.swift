//
//  ExhibitionsModel.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/2/25.
//

import Foundation

struct Exhibition: Codable, Identifiable {
    let id: Int
    let title: String
    let enddate: String?
    let begindate: String?
    let description: String?
    let primaryimageurl: String?
}

class ExhibitionsModel: ObservableObject {
    
    @Published var data: [Exhibition] = []
    
    func load() async {
        let exhibitions = await UtilModel.fetchData()
        Task { @MainActor in
            data = exhibitions
        }
    }
}
