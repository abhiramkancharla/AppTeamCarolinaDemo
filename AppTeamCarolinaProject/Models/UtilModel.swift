//
//  HarvardMsmApi.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 9/1/25.
//

import Foundation

class HarvardMsmApi {
    
    public static func getTextDate(begin: String, end: String) -> [String] {
        let beginArray = begin.components(separatedBy: "-")
        let beginMonth = beginArray[1]
        let beginDay = beginArray[2]
        
        let endArray = end.components(separatedBy: "-")
        let endMonth = endArray[1]
        let endDay = endArray[2]
        
        let convertedBeginMonth = monthValues[Int(beginMonth)!]
        let convertedEndMonth = monthValues[Int(endMonth)!]
        
        return ["\(convertedBeginMonth ?? "DNE") \(beginDay)", "\(convertedEndMonth ?? "DNE") \(endDay)"]
    }
    
    public static func fetchData() async -> [Exhibition] {
        let apiKey = "64130bba-357c-49f1-9b1e-7286e2754225"
        let url = URL(string: "https://api.harvardartmuseums.org/exhibition?apikey=\(apiKey)&size=10")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let records = json["records"] as? [[String: Any]] {
                
                let decoder = JSONDecoder()
                let recordsData = try JSONSerialization.data(withJSONObject: records)
                var decoded = try decoder.decode([Exhibition].self, from: recordsData)
                
                print(json)
                
                // ✅ Skip exhibitions without description or image
                decoded = decoded.filter { $0.primaryimageurl != nil }
                
                return decoded
            }
        } catch {
            print("Error fetching data: \(error)")
            return [Exhibition(id: 0, title: "Cannot Fetch", enddate: "", begindate: "", description: "", primaryimageurl: "")]
        }

    }
}
