//
//  TabBarView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 10/11/22.
//
import SwiftUI

enum TabsBar: String {
    case listenNow
    case search
    case library
}

struct TabBarView: View {
    
    @State var currentTab: TabsBar = .search
    @State private var expandPlayer: Bool = false
    @State private var query: String = ""
    @State private var searchResult: [SearchResultItems] = []
    
    @Namespace private var animation
    
    @StateObject var userProfile = UserProfileFetcher()
    @StateObject var currentPlayer = CurrentlyPlayerFetcher()
    @StateObject var searchFetcher = SearchFetcher()
    
    
    var body: some View {
        if #available(iOS 16.0, *) {
            TabView(selection: $currentTab) {
                ListenNowView()
                    .tag(TabsBar.listenNow)
                    .tabItem {
                        Image(systemName: "play.circle.fill")
                        Text("Listen Now")
                    }
                    .toolbar(expandPlayer ? .hidden : .visible, for: .tabBar)
                
                CustomNavigationView(view: SearchView(query: self.$query, searchResult: self.$searchResult), onSearch: { txt in
                    APICaller.shared.getSearch(key: txt) { result in
                        self.query = txt
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let success):
                                self.searchResult = success.tracks.items
                            case .failure(let error):
                                print( "tes \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    
                }, onCancel: {
                    self.query = ""
                    print("cancel")
                })
                    .ignoresSafeArea()
                    .tag(TabsBar.search)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .toolbar(expandPlayer ? .hidden : .visible, for: .tabBar)

                LibraryView()
                    .tag(TabsBar.library)
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Library")
                    }
                    .toolbar(expandPlayer ? .hidden : .visible, for: .tabBar)
            }
            .accentColor(.pink)
            .safeAreaInset(edge: .bottom) {
                if currentPlayer.currentlyPlayer?.is_playing == true {
                    NewMiniPlayer(expandPlayer: $expandPlayer, animation: animation, coverImage: currentPlayer.currentlyPlayer?.item.album.images[1].url, songTitle: currentPlayer.currentlyPlayer?.item.name)
                }
            }
            .overlay {
                if expandPlayer {
                    ExpandedPlayer(expandPlayer: $expandPlayer, animation: animation, coverImage: currentPlayer.currentlyPlayer?.item.album.images[1].url, songTitle: currentPlayer.currentlyPlayer?.item.name, artistName: currentPlayer.currentlyPlayer?.item.album.artists[0].name)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                }
            }
            .ignoresSafeArea(.keyboard)
            
        } else {
            TabView(selection: $currentTab) {
                ListenNowView()
                    .tag(TabsBar.listenNow)
                    .tabItem {
                        Image(systemName: "play.circle.fill")
                        Text("Listen Now")
                    }
                    
                
                CustomNavigationView(view: SearchView(query: self.$query, searchResult: self.$searchResult), onSearch: { txt in
                    APICaller.shared.getSearch(key: txt) { result in
                        self.query = txt
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let success):
                                self.searchResult = success.tracks.items
                            case .failure(let error):
                                print( "tes \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    
                }, onCancel: {
                    self.query = ""
                    print("cancel")
                })
                    .ignoresSafeArea()
                    .tag(TabsBar.search)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }

                LibraryView()
                    .tag(TabsBar.library)
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill")
                        Text("Library")
                    }
                    
            }
            .accentColor(.pink)
            .safeAreaInset(edge: .bottom) {
                if currentPlayer.currentlyPlayer?.is_playing == true {
                    NewMiniPlayer(expandPlayer: $expandPlayer, animation: animation, coverImage: currentPlayer.currentlyPlayer?.item.album.images[1].url, songTitle: currentPlayer.currentlyPlayer?.item.name)
                }
            }
            .overlay {
                if expandPlayer {
                    ExpandedPlayer(expandPlayer: $expandPlayer, animation: animation, coverImage: currentPlayer.currentlyPlayer?.item.album.images[1].url, songTitle: currentPlayer.currentlyPlayer?.item.name, artistName: currentPlayer.currentlyPlayer?.item.album.artists[0].name)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                }
            }
            .ignoresSafeArea(.keyboard)

        }
    }

//    @ViewBuilder
//    func NewMiniPlayer() -> some View {
//        ZStack {
//            Rectangle()
//                .fill(.ultraThickMaterial)
//                .overlay {
//                    MusicInfo()
//                }
//        }
//        .frame(height: 70)
//        .overlay(alignment: .bottom, content: {
//            Rectangle()
//                .fill(.gray.opacity(0.3))
//                .frame(height: 1)
//              .offset(y: -10)
//        })
//        .offset(y: -49)
//    }
    
//    @ViewBuilder
//    func TabList(_ title: String, _ icon: String) -> some View {
//        Text(title)
//            .tabItem {
//                Image(systemName: icon)
//                Text(title)
//            }
//    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
