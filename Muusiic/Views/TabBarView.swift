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
    @Namespace private var animation
    
    @State var isTyping: Bool = false
    
    @StateObject var currentPlayer = CurrentlyPlayerFetcher()
    
    
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
                
                SearchView(isTyping: $isTyping)
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
            .safeAreaInset(edge: .bottom) {
                if currentPlayer.currentlyPlayer?.is_playing != false {
                    NewMiniPlayer(expandPlayer: $expandPlayer, animation: animation)
                }
            }
            .overlay {
                if expandPlayer {
                    ExpandedPlayer(expandPlayer: $expandPlayer, animation: animation)
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
                    
                
                SearchView(isTyping: $isTyping)
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
            .safeAreaInset(edge: .bottom) {
                NewMiniPlayer(expandPlayer: $expandPlayer, animation: animation)
            }
            .overlay {
                if expandPlayer {
                    ExpandedPlayer(expandPlayer: $expandPlayer, animation: animation)
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
////                .offset(y: -10)
//        })
//        .offset(y: -49)
//    }
//    
    
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
