//
//  TabBarView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 10/11/22.
//

import SwiftUI

enum TabsTitle: String {
    case listenNow
    case search
    case library
}

struct TabBarView: View {
    
    @State var current: TabsTitle = .search
    @State var expand = false
    @State var isTyping: Bool = false
    
    @StateObject var currentPlayer = CurrentlyPlayerFetcher()
    
    @Namespace var animation
    
    
    var body: some View {
        
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    TabView(selection: $current) {
                        ListenNowView()
                            .tag(TabsTitle.listenNow)
                            .tabItem {
                                Image(systemName: "play.circle.fill")
                                Text("Listen Now")
                            }

                        SearchView(isTyping: $isTyping)
                            .tag(TabsTitle.search)
                            .tabItem {
                                Image(systemName: "magnifyingglass")
                                Text("Search")
                            }
                        
                        LibraryView()
                            .tag(TabsTitle.library)
                            .tabItem {
                                Image(systemName: "rectangle.stack.fill")
                                Text("Library")
                            }
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)


                if (currentPlayer.currentlyPlayer?.is_playing == true) {
                    MiniPlayer(animation: animation, expand: $expand, isTyping: $isTyping)
                } else {
                    EmptyView()
                }
                
            }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
