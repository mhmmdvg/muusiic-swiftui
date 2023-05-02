//
//  MiniPlayer.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 10/11/22.
//

import SwiftUI

struct MiniPlayer: View{
    
    var animation: Namespace.ID
    var height = UIScreen.main.bounds.height / 3
    
    @State var volume: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var play: Bool = true
    
    @StateObject var currentlyPlayerFetcher = CurrentlyPlayerFetcher()

    @Binding var expand: Bool
    @Binding var isTyping: Bool
    
    
    var body: some View {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let safeArea = windowScene?.windows.first?.safeAreaInsets
        
        VStack {
            
            Capsule()
                .fill(Color.gray)
                .frame(width: expand ? 60 : 0, height: expand ? 4 : 0)
                .opacity(expand ? 1 : 0)
                .padding(.top, expand ? safeArea?.top : 0)
                .padding(.vertical, expand ? 30 : 0)
            
            // Small
            HStack(spacing: 15) {
                
                if expand { Spacer(minLength: 0) }
                
                AsyncImage(
                    url: currentlyPlayerFetcher.currentlyPlayer?.item.album.images[0].url)
                    { phase in
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                 .frame(width: expand ? height : 45, height: expand ? height : 45)
                                 .cornerRadius(10)
                        } else if phase.error != nil {
                            Text(phase.error?.localizedDescription ?? "error")
                                .foregroundColor(.pink)
                                .frame(width: expand ? height : 45, height: expand ? height : 45)
                        } else {
                            ProgressView()
                                .frame(width: expand ? height : 45, height: expand ? height : 45)
                        }
                    }
                
                
                
                
                if !expand {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(currentlyPlayerFetcher.currentlyPlayer?.item.name ?? "Song Title")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                   
                        
                        Text(currentlyPlayerFetcher.currentlyPlayer?.item.album.artists[0].name ?? "Artist")
                    }
                    .matchedGeometryEffect(id: "Label", in: animation)


                }
                
                Spacer(minLength: 0)
                

                if !expand {
                    Button(action: {
                        APICaller.shared.postPreviousPlayer { success in
                            if success {
                                currentlyPlayerFetcher.fetchCurrentlyPlayer()
                                self.play = true
                            } else {
                                print("Gagal")
                            }
                        }
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    if currentlyPlayerFetcher.currentlyPlayer?.is_playing == true {
                        if play {
                            Button(action: {
                                APICaller.shared.putPausePlayer { success in
                                    if success {
                                        self.play = false
                                    } else {
                                        print("Gagal")
                                    }
                                }
                            }) {
                                Image(systemName: "pause.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                
                            }
                            .padding(.horizontal, 2)
                        } else {
                            Button(action: {
                                APICaller.shared.putResumeStartPlayer { success in
                                    if success {
                                        self.play = true
                                    } else {
                                        print("Gagal")
                                    }
                                }
                            }) {
                                Image(systemName: "play.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                
                            }
                            .padding(.horizontal, 2)
                        }
                    } else {
                        EmptyView()
                    }
                    
                    Button(action: {
                        APICaller.shared.postNextPlayer { success in
                            if success {
                                currentlyPlayerFetcher.fetchCurrentlyPlayer()
                                self.play = true
                            } else {
                                print("Gagal")
                            }
                        }
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                
                Spacer(minLength: 0)
                
                HStack {
                    
                    if expand {
                        VStack(alignment: .leading, spacing: 5){
                            Text(currentlyPlayerFetcher.currentlyPlayer?.item.name ?? "Song Title")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .fontWeight(.bold)
                            
                            Text(currentlyPlayerFetcher.currentlyPlayer?.item.album.artists[0].name ?? "Artist")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                        .matchedGeometryEffect(id: "Label", in: animation)


                    }
                    
                    Spacer(minLength: 0)
                    Button(action: {}) {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                .padding(.top, 15)
                
                HStack {
                    Capsule()
                        .fill(
                            LinearGradient(gradient: .init(colors: [Color.white.opacity(0.7), Color.white.opacity(0.1)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(height: 4)
                    
                    Text("LIVE")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Capsule()
                        .fill(
                            LinearGradient(gradient: .init(colors: [Color.white.opacity(0.1), Color.white.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(height: 4)
                }
                .padding()
                
                
                HStack(spacing: 30) {
                    Button(action: {
                        APICaller.shared.postPreviousPlayer { success in
                            if success {
                                currentlyPlayerFetcher.fetchCurrentlyPlayer()
                                self.play = true
                            } else {
                                print("Gagal")
                            }
                        }
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }
                    
                    if play {
                        Button(action: {
                            APICaller.shared.putPausePlayer { success in
                                if success {
                                    self.play = false
                                } else {
                                    print("Gagal")
                                }
                            }
                        }) {
                            Image(systemName: "pause.fill")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                            
                        }
                    } else {
                        Button(action: {
                            APICaller.shared.putResumeStartPlayer { success in
                                if success {
                                    self.play = true
                                } else {
                                    print("Gagal")
                                }
                            }
                        }) {
                            Image(systemName: "play.fill")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                            
                        }
                    }
                    
                    Button(action: {
                        APICaller.shared.postNextPlayer { success in
                            if success {
                                currentlyPlayerFetcher.fetchCurrentlyPlayer()
                                self.play = true
                            } else {
                                print("Gagal")
                            }
                        }
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
                Spacer(minLength: 0)
                
                HStack(spacing: 15) {
                    Image(systemName: "speaker.fill")
                    
                    Slider(value: $volume)
                    
                    Image(systemName: "speaker.wave.2.fill")
                }
                .padding()
                
                HStack(spacing: 22) {
                    
                    Button( action: {}) {
                        
                        Image(systemName: "arrow.up.message")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }

                    
                    Button( action: {}) {
                        
                        Image(systemName: "airplayaudio")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    Button( action: {}) {
                        
                        Image(systemName: "list.bullet")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    
                    
                }
                .padding(.bottom, safeArea?.bottom == 0 ? 55 : safeArea?.bottom)
            }
            .frame(height: expand ? nil : 0)
            .opacity(expand ? 1 : 0)
        }
        .frame(maxHeight: expand ? .infinity :  65)
        .background(
            VStack(spacing: 0, content: {
                BlurView()
                Divider()
            })
            .onTapGesture(perform: {
                withAnimation(.spring()) { expand = true }
            })
        )
        .cornerRadius(expand ? 20 : 0)
        .offset(y: expand ? 0 : -49)
        .offset(y: offset)
        .gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:)))
        .ignoresSafeArea()
        .opacity(isTyping ? 0 : 1)
    }
    
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.height > 0 && expand {
            offset = value.translation.height
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {

            if value.translation.height > height {
                expand = false
            }
            offset = 0
        }
    }
}

//struct MiniPlayer_Previews: PreviewProvider {
//    static var previews: some View {
//        MiniPlayer(animation: <#Namespace.ID#>, expand: <#Binding<Bool>#>, isTyping: <#Binding<Bool>#>)
//    }
//}
