//
//  ExhibitionView.swift
//  AppTeamCarolinaProject
//
//  Created by Abhiram Kancharla on 8/30/25.
//

import SwiftUI

struct ExhibitionView: View {
    
    var thumbnail: URL
    var dates: String
    var title: String
    var desc: String
        
    var body: some View {
        
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.clear)
            
            VStack {
                AsyncImage(url: thumbnail) { image in
                    image
                        .image?.resizable()
                        .frame(width: 375, height: 175)
                        .cornerRadius(10)
                }
                .padding([ .leading, .trailing], 25)
                .padding([.bottom], -20)
                HStack {
                    Text(title)
                        .bold()
                        .font(.title2)
                        .padding()
                    Spacer()
                    Text(dates)
                        .foregroundStyle(.gray)
                        .font(.headline)
                        .bold()
                        .padding()
                }
                .padding()
                HStack {
                    Text(desc)
                        .padding([.leading, .trailing])
                        .foregroundStyle(.gray)
                        .offset(y: -20)
                    Spacer()
                }
                .padding([.leading])
                Spacer()
            }
            
            
        }
    }
}

#Preview {
    ExhibitionView(thumbnail: URL(string: "https://nrs.harvard.edu/urn-3:HUAM:GS07977")!, dates: "Jan 31 - Jun 1", title: "In Harmony", desc: "No Desc")
        .frame(width: 400, height: 325)
}
