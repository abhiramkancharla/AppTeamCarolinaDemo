//
//  HarvardMsmApi.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/1/25.
//

import Foundation

let monthValues: [Int: String] = [
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "Jun",
    7: "Jul",
    8: "Aug",
    9: "Sep",
    10: "Oct",
    11: "Nov",
    12: "Dec"
]

class UtilModel {
    
    public static func getTextDate(begin: String, end: String) -> String {
        
        if (begin.isEmpty || end.isEmpty) {
            return ""
        }
        
        let beginArray = begin.components(separatedBy: "-")
        let beginMonth = beginArray[1]
        let beginDay = beginArray[2]
        
        let endArray = end.components(separatedBy: "-")
        let endMonth = endArray[1]
        let endDay = endArray[2]
        
        let convertedBeginMonth = monthValues[Int(beginMonth)!]
        let convertedEndMonth = monthValues[Int(endMonth)!]
        
        return "\(convertedBeginMonth ?? "DNE") \(beginDay) - \(convertedEndMonth ?? "DNE") \(endDay)"
    }
    
    public static func fetchExhibitionIDs() async -> [Int] {
        let apiKey = "64130bba-357c-49f1-9b1e-7286e2754225"
        let url = URL(string: "https://api.harvardartmuseums.org/exhibition?apikey=\(apiKey)&size=1000&page=5")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let records = json["records"] as? [[String: Any]] {
                
                return records.compactMap { $0["id"] as? Int }
            }
        } catch {
            print("Error fetching exhibition IDs: \(error)")
        }
        
        return []
    }
    
    public static func fetchExhibitionDetail(id: Int) async -> Exhibition? {
        let apiKey = "64130bba-357c-49f1-9b1e-7286e2754225"
        let url = URL(string: "https://api.harvardartmuseums.org/exhibition/\(id)?apikey=\(apiKey)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            
            let decoder = JSONDecoder()
            
            let exhibition = try decoder.decode(Exhibition.self, from: data)
            
            return exhibition
        } catch {
            print("Error fetching exhibition \(id): \(error)")
            return nil
        }
    }
    
    public static func fetchAllExhibitions() async -> [Exhibition] {
        var all: [Exhibition] = []
        
        let ids = await fetchExhibitionIDs()
        
        for id in ids {
            if let detail = await fetchExhibitionDetail(id: id) {
                all.append(detail)
            }
        }
        
        return all
    }


    
    public static func fetchData() async -> [Exhibition] {
        let apiKey = "64130bba-357c-49f1-9b1e-7286e2754225"
        let url = URL(string: "https://api.harvardartmuseums.org/exhibition?apikey=\(apiKey)&size=1000")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let records = json["records"] as? [[String: Any]] {
                
                let decoder = JSONDecoder()
                let recordsData = try JSONSerialization.data(withJSONObject: records)
                var decoded = try decoder.decode([Exhibition].self, from: recordsData)
                                
                decoded = decoded.filter { $0.primaryimageurl != nil }
                
                return decoded
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
        return [Exhibition(id: 0, title: "Cannot Fetch", enddate: "", begindate: "", description: "", primaryimageurl: "")]

    }

    
    @MainActor
    public static func fetchArtworks(for exhibitionId: Int) async -> [Artwork] {
        let apiKey = "64130bba-357c-49f1-9b1e-7286e2754225"
        var allArtworks: [Artwork] = []
        var page = 1
        var hasMore = true
        
        while hasMore {
            // Build URL depending on exhibitionId
            let baseURL: String
            if exhibitionId == 0 {
                baseURL = "https://api.harvardartmuseums.org/object?apikey=\(apiKey)&size=100&page=\(page)"
            } else {
                baseURL = "https://api.harvardartmuseums.org/object?exhibition=\(exhibitionId)&apikey=\(apiKey)&size=100&page=\(page)"
            }
            
            guard let url = URL(string: baseURL) else { break }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let recordsArray = json["records"] as? [[String: Any]] {
                    
                    let artworks: [Artwork] = recordsArray.compactMap { recordDict in
                        guard let objectNumber = recordDict["objectnumber"] as? String else { return nil }
                        
                        // Extract fields
                        let id = abs(objectNumber.hashValue)
                        let date = recordDict["dated"] as? String
                        let title = (recordDict["title"] as? String) ?? objectNumber
                        let description = (recordDict["description"] as? String) ?? ""
                        let primaryimageurl = (recordDict["primaryimageurl"] as? String) ?? ""
                        
                        var artist = "Uknown"
                        if let peopleArray = recordDict["people"] as? [[String: Any]],
                           let firstPerson = peopleArray.first,
                           let displayName = firstPerson["displayname"] as? String {
                            artist = displayName
                        }
                        
                        return Artwork(
                            id: id,
                            date: date,
                            title: title,
                            artist: artist,
                            description: description,
                            primaryimageurl: primaryimageurl
                        )
                    }
                    
                    allArtworks.append(contentsOf: artworks)
                    
                    // Stop if no more pages
                    if let info = json["info"] as? [String: Any],
                       let next = info["next"] as? String {
                        hasMore = true
                        page += 1
                    } else {
                        hasMore = false
                    }
                    
                } else {
                    hasMore = false
                }
                
            } catch {
                print("Error fetching data: \(error)")
                hasMore = false
            }
        }
        
        return allArtworks.isEmpty ? [Artwork(id: 0, date: "", title: "", artist: "", description: "", primaryimageurl: "")] : allArtworks
    }
}
