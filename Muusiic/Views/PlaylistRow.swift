//
//  PlaylistRow.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 28/11/22.
//

import SwiftUI

struct PlaylistRow: View {
    
    let imageUrl: URL?
    let playlistName: String?
    let playlistDesc: String?
    
    var body: some View {
        HStack(spacing: 10) {
            
            AsyncImage(url: imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (UIScreen.main.bounds.width - 50) / 3.8, height: 90)
                    .cornerRadius(6)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(playlistName ?? "Playlist Name")
                    .font(.title3)
                if playlistDesc != nil {
                    Text(playlistDesc ?? "Playlist Description")
                        .foregroundColor(.gray)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

struct PlaylistRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistRow(
            imageUrl: URL(string: "https://i.scdn.co/image/ab67616d0000b273c4a9bdd7f2b255da05f6d481"),
            playlistName: "iKon",
            playlistDesc: "Lagu Asyik"
        )
    }
}
