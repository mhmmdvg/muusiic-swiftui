//
//  AccountSettingView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 05/05/23.
//

import SwiftUI

struct AccountSettingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var loginView = false
    
    private func handleLogOut(success: Bool) {
        guard success else {
            return
        }
        self.loginView = success
    }
    
    var body: some View {
        NavigationView {
                List {
                    Section {
                        NavigationLink(destination: Text("ehehe")) {
                            HStack(spacing: 12) {
                                CircleImageView(image: URL(string: "https://i.scdn.co/image/ab67616d0000b273f0b9b2e2a024d7d87a21ffed")!)
                                
                                VStack(alignment: .leading) {
                                    Text("Muhammad Vikri")
                                        .font(.title3)
                                    Text("muhammadvikrii99@gmail.com")
                                        .font(.callout)
                                        .tint(.gray)
                                }
                            }
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: Text("Account Details")) {
                            Text("Account")
                        }
                        
                        NavigationLink(destination: Text("Data Saver")) {
                            Text("Data Saver")
                        }
                        
                        NavigationLink(destination: Text("Devices")) {
                            Text("Devices")
                        }
                    }
                    
                    Section {
                        Button {
                            AuthService.shared.signOutAction { success in
                                DispatchQueue.main.async {
                                    
                                    self.handleLogOut(success: success)
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        } label: {
                            Text("Log out")
                        }
                        .foregroundColor(.pink)
                    }
                }
        }
        .fullScreenCover(isPresented: $loginView) {
            LoginView()
        }
    }
}

struct AccountSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingView()
    }
}
