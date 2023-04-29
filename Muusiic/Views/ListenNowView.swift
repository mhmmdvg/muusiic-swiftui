//
//  LibraryView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import SwiftUI

struct ListenNowView: View {
    
    @StateObject var currentPlaylistUser = CurrentPlaylistFetcher()
    @StateObject var userProfile = UserProfileFetcher()
    @StateObject var recentlyPlayed = RecentlyPlayedFetcher()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Divider()
                        .padding(.horizontal)
                    PlaylistHorizontalGrid(currentPlaylist: currentPlaylistUser.currentPlaylist)
                    Spacer(minLength: 20)
                    Divider()
                        .padding(.horizontal)
                    RecentlyPlayed(getRecentlyPlayed: recentlyPlayed.recentlyPlayedFetch)
                }
                .navigationTitle("Listen Now")
                .overlay(
                    CircleImageView(image: userProfile.userProfileFetch?.images[0].url)
                        .padding(.trailing, 20)
                        .offset(x: 0, y: -50)
                    ,alignment: .topTrailing)
                .padding(.bottom, 80)
            }            
        }
    }
}

struct ListenNowView_Previews: PreviewProvider {
    static var previews: some View {
        ListenNowView()
    }
}
