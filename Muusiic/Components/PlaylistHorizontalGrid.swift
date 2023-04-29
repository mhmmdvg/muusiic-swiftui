//
//  PlaylistHorizontalGrid.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 26/11/22.
//

import SwiftUI

struct PlaylistHorizontalGrid: View {
    
    var currentPlaylist: [PlaylistUserItems]
    var grids = Array(repeating: GridItem(.flexible()), count: 1)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Your Playlist")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                Spacer()
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    LazyHGrid(rows: grids) {
                        ForEach(currentPlaylist.prefix(10), id: \.self) { item in
                            Button(action: {}) {
                                VStack {
                                    CacheAsyncImage(url: item.images[0].url) { phase in
                                        if let image = phase.image {
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: UIScreen.main.bounds.width / 1.5, height: 350)
                                                .overlay(alignment: .bottom) {
                                                    VStack {
                                                        Text(item.name)
                                                            .font(.system(size: 18))
                                                            .fontWeight(.semibold)
                                                            .lineLimit(2)
                                                            .foregroundColor(.primary)
                                                        if item.description != "" {
                                                            Text(item.description)
                                                                .font(.system(size: 16))
                                                                .foregroundColor(.gray)
                                                                .lineLimit(2)
                                                                .padding(.horizontal)
                                                        } else {
                                                            Text("By \(item.owner.display_name)")
                                                                .foregroundColor(.gray)
                                                                .padding(.horizontal)
                                                        }
                                                    }
                                                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 9)
                                                    .background(BlurView())
                                                }
                                        } else if phase.error != nil {
                                            Text(phase.error?.localizedDescription ?? "error")
                                                .frame(width: UIScreen.main.bounds.width / 1.5, height: 350)
                                        } else {
                                            ProgressView()
                                        .frame(width: UIScreen.main.bounds.width / 1.5, height: 350)
                                        .overlay(alignment: .bottom) {
                                            VStack {
                                                Text("Title")
                                                    .font(.system(size: 18))
                                                    .fontWeight(.semibold)
                                                    .lineLimit(2)
                                                    .foregroundColor(.primary)
                                                Text("Description")
                                                    .foregroundColor(.gray)
                                                    .lineLimit(2)
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 9)
                                            .background(BlurView())
                                        }
                                        }
                                    }
                                }
                                .cornerRadius(14)
                                .padding(.horizontal, 5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
//        .onAppear {
//            URLCache.shared.memoryCapacity = 1024 * 1024 * 512
//        }
    }
}

struct PlaylistHorizontalGrid_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistHorizontalGrid(currentPlaylist: CurrentPlaylistFetcher().currentPlaylist)
    }
}
