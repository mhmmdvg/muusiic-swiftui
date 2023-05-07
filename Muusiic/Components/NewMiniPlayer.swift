//
//  MusicInfo.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 30/04/23.
//

import SwiftUI

struct NewMiniPlayer: View {
    
    @Binding var expandPlayer: Bool
    var animation: Namespace.ID
    var coverImage: URL?
    var songTitle: String?
    
    var body: some View {
        ZStack {
            // Animating Sheet Background
            if expandPlayer {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.thinMaterial)
                    .overlay {
                        MusicInfo(
                            expandSheet: $expandPlayer,
                            animation: animation,
                            coverImage: coverImage ?? URL(string: "https://i.scdn.co/image/ab67616d0000b273f0b9b2e2a024d7d87a21ffed")!,
                            songTitle: songTitle ?? "Undefined"
                        )
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
            
        }
        .frame(height: 70)
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 1)
//                .offset(y: -10)
        })

        .offset(y: -49)
//        .ignoresSafeArea(.keyboard)
        

    }
}

struct NewMiniPlayer_Previews: PreviewProvider {
    static var previews: some View {
            TabBarView()
    }
}



struct MusicInfo: View {
    
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    var coverImage: URL
    var songTitle: String
    
    @EnvironmentObject var playing: PlaySetting
    
    @StateObject var currentlyPlayerFetcher = CurrentlyPlayerFetcher()
    
    var body: some View {
        HStack(spacing: 0) {
            
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        let size = $0.size
                        
                        CacheAsyncImage(url: coverImage) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: size.height)
                                    .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15 : 5, style: .continuous))
                            } else if phase.error != nil {
                                Text(phase.error?.localizedDescription ?? "error")
                                    .frame(width: size.width, height: size.height)
                            } else {
                                ProgressView()
                                    .frame(width: size.width, height: size.height)
                            }
                        }
                    }
                    .matchedGeometryEffect(id: "cover", in: animation)
                }
            }
            .frame(width: 45, height: 45)
            
            
            Text(songTitle)
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 15)
            
            Spacer(minLength: 0)
            
                
            if playing.play {
                Button {
                    APICaller.shared.putPausePlayer { success in
                        if success {
                            self.playing.play = false
                        } else {
                            print("Failed")
                        }
                    }
                } label: {
                    Image(systemName: "pause.fill")
                        .font(.title2)
                }
            } else {
                Button {
                    APICaller.shared.putResumeStartPlayer { success in
                        if success {
                            self.playing.play = true
                        } else {
                            print("Failed")
                        }
                    }
                } label: {
                    Image(systemName: "play.fill")
                        .font(.title2)
                }

            }
            
            Button {
                APICaller.shared.postNextPlayer { success in
                    if success {
                        currentlyPlayerFetcher.fetchCurrentlyPlayer()
                        self.playing.play = true
                    } else {
                        print("Failed")
                    }
                }
            } label: {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .padding(.leading, 25)
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}
