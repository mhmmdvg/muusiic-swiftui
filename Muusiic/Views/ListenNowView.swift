//
//  LibraryView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import SwiftUI

struct ListenNowView: View {
    
    @State private var showModal: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
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
                .padding(.bottom, 80)
                .navigationTitle("Listen Now")
                .navigationBarLargeTitleItems(trailing: ProfileImage(showModal: $showModal))
            }
        }
        .sheet(isPresented: self.$showModal) {
            UserSettingModal(isPresented: self.$showModal)
            
        }
    }
}

struct ListenNowView_Previews: PreviewProvider {
    static var previews: some View {
        ListenNowView()
    }
}


struct UserSettingModal: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    
    @State var destination: AnyView? = nil
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        NavigationLink(destination: Text("Kesana")) {
                            Text("Notification")
                        }
                    }

                    Section {
                        Button {
                            self.isPresented = false

                        } label: {
                            Text("Account Settings")
                        }
                    }
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                        .foregroundColor(.pink)
                }
            }
        }
    }
}
