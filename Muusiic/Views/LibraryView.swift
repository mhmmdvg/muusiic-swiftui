//
//  LibraryView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import SwiftUI

struct LibraryView: View {
    
    @StateObject var currentPlaylistUser = CurrentPlaylistFetcher()
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns) {
                        ForEach(currentPlaylistUser.currentPlaylist, id: \.self ) { item in
                            VStack(alignment: .leading){
                                AsyncImage(url: item.images[0].url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 180)
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                
                                
                                Text(item.name)
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                
                                if item.description != "" {
                                    Text(item.description)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                } else {
                                    Text("By \(item.owner.display_name)")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 5)

                        }
                    }
                }
                .padding()
                .padding(.bottom, 80)
            }
            .navigationTitle("Library")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
