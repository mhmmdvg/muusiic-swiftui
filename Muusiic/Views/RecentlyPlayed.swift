//
//  RecentlyPlayed.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 26/11/22.
//

import SwiftUI

struct RecentlyPlayed: View {
    
    let getRecentlyPlayed: [RecentlyPlayedItems]
    var grids = Array(repeating: GridItem(.flexible()), count: 1)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("Recently Played")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                Spacer()
                Button(action: {}) {
                    Text("See All")
                        .foregroundColor(.pink)
                }
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    LazyHGrid(rows: grids) {
                        ForEach(getRecentlyPlayed, id: \.self) { item in
                            Button(action: {}) {
                                VStack(alignment: .leading) {
                                    AsyncImage(url: item.track.album.images[0].url) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 170)
                                            .cornerRadius(12)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    Text(item.track.name)
                                        .lineLimit(1)
                                        .foregroundColor(.primary)
                                    
                                    Text(item.track.artists[0].name)
                                        .lineLimit(1)
                                        .foregroundColor(.gray)

                                }
                                .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                .padding(.horizontal, 2)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}

struct RecentlyPlayed_Previews: PreviewProvider {
    static var previews: some View {
        RecentlyPlayed(getRecentlyPlayed: RecentlyPlayedFetcher().recentlyPlayedFetch)
    }
}
