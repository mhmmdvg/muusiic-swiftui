//
//  ExpandedPlayer.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 30/04/23.
//

import SwiftUI

struct ExpandedPlayer: View {
    
    @Binding var expandPlayer: Bool
    var animation: Namespace.ID
    
    @StateObject var currentlyPlayerFetcher = CurrentlyPlayerFetcher()
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    @EnvironmentObject private var playing: PlaySetting
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                            .fill(LinearGradient(colors: [.gray.opacity(1), .black.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                            .opacity(animateContent ? 1 : 0)
                    })
                    .overlay(alignment: .top) {
                        MusicInfo(
                            expandSheet: $expandPlayer,
                            animation: animation,
                            coverImage: currentlyPlayerFetcher.currentlyPlayer?.item.album.images[1].url ?? URL(string: "https://i.scdn.co/image/ab67616d0000b273f0b9b2e2a024d7d87a21ffed")!,
                            songTitle: currentlyPlayerFetcher.currentlyPlayer?.item.name ?? "Undefined"
                        )
                        //Disabling Interaction (sicne its not necessary here)
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                
                VStack(spacing: 15) {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                    // Mathing with Slide Animation
                        .offset(y: animateContent ? 0 : size.height)
                    
                    GeometryReader {
                        let size = $0.size
                        
                        CacheAsyncImage(url: currentlyPlayerFetcher.currentlyPlayer?.item.album.images[1].url ?? URL(string: "https://i.scdn.co/image/ab67616d0000b273f0b9b2e2a024d7d87a21ffed")!) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: size.height)
                                    .clipShape(RoundedRectangle(cornerRadius: animateContent ? 15 : 5, style: .continuous))
                            }
                        }
                    }
                    .matchedGeometryEffect(id: "cover", in: animation)
                    .frame(height: size.width - 50)
                    
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    // Player View
                    playerView(size)
                    /// Moving it from Bottom
                        .offset(y: animateContent ? 0 : size.height)
                    
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                // For testing UI
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        expandPlayer = false
                        animateContent = false
                    }
                }
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if offsetY > size.height * 0.4 {
                                expandPlayer = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
            
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
    
    @ViewBuilder
    func playerView(_ mainSize: CGSize) -> some View {
        GeometryReader {
            let size = $0.size
            /// Dynamic Spacing Using Available height
            let spacing = size.height * 0.04
            
            // Sizing it for more compact look
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentlyPlayerFetcher.currentlyPlayer?.item.name ?? "Undefined")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(currentlyPlayerFetcher.currentlyPlayer?.item.album.artists[0].name ?? "Undefined")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(12)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        }
                    }
                    
                    // Timing Indicator
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .light)
                        .frame(height: 5)
                        .padding(.top, spacing)
                    
                    // Timing label
                    HStack {
                        Text("0:00")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text("3:33")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                // Playback Controls
                HStack(spacing: size.width * 0.18) {
                    Button {
                        APICaller.shared.postPreviousPlayer { success in
                            if success {
                                currentlyPlayerFetcher.fetchCurrentlyPlayer()
                                self.playing.play = true
                            } else {
                                print("Failed")
                            }
                        }
                    } label: {
                        Image(systemName: "backward.fill")
                            // Dynamic sizing for smaller to larger iphone
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    
                    if playing.play {
                        Button {
                            APICaller.shared.putPausePlayer { success in
                                self.playing.play = false
                            }
                        } label: {
                            Image(systemName: "pause.fill")
                                // Dynamic sizing for smaller to larger iphone
                                .font(size.height < 300 ? .largeTitle : .system(size: 50))
                        }
                    } else {
                        Button {
                            APICaller.shared.putResumeStartPlayer { success in
                                self.playing.play = true
                            }
                        } label: {
                            Image(systemName: "play.fill")
                                // Dynamic sizing for smaller to larger iphone
                                .font(size.height < 300 ? .largeTitle : .system(size: 50))
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
                            // Dynamic sizing for smaller to larger iphone
                            .font(size.height < 300 ? .title3 : .title)
                    }

                }
                .foregroundColor(.white)
                .frame(maxHeight: .infinity)
                
                // Volume & Other Controls
                VStack(spacing: spacing) {
                    HStack(spacing: 15) {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.gray)
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.gray)
                    }
                    
                    HStack(alignment: .top, spacing: size.width * 0.18) {
                        Button {
                            
                        } label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        }
                        
                        
                        VStack(spacing: 6) {
                            Button {
                                
                            } label: {
                                Image(systemName: "airpods.gen3")
                                    .font(.title2)
                            }

                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        }

                    }
                    .foregroundColor(.white)
                    .blendMode(.overlay)
                    .padding(.top, spacing)
                }
                .frame(height: size.height / 2.5, alignment: .bottom)
            }
        }
    }
}

struct ExpandedPlayer_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}


extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            
             return 0
        }
        
        return 0
    }
}
