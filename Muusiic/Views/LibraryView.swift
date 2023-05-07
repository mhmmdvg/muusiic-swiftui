//
//  ProfileView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 22/11/22.
//

import SwiftUI

struct LibraryView: View {
    
    @StateObject var currentPlaylistUser = CurrentPlaylistFetcher()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(currentPlaylistUser.currentPlaylist, id: \.self) { item in
                    NavigationLink {
                        PlaylistDetailView()
                    } label: {
                        PlaylistRow(
                            imageUrl: item.images[0].url,
                            playlistName: item.name,
                            playlistDesc: item.description)

                    }

                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Library")
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundColor(.pink)
                            .font(.title3)
                    }
                }
            })
            
        }
//        .onAppear {
////            print("cache \(URLCache.shared.memoryCapacity / 1024) KB")
//            URLCache.shared.memoryCapacity = 1024 * 1024 * 512
//        }
       
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
