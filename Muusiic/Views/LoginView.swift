//
//  LoginView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 09/09/22.
//

import SwiftUI


struct LoginView: View {
    
    @StateObject var viewModel = SignInViewModel()
    @State var tabBar = false
    
      
    private func handleSignIn(success: Bool) {
        guard success else {
            return
        }
        
        self.tabBar = success
    }
    
      var body: some View {
          NavigationView {
              VStack(spacing: 16) {
                  Image(systemName: "person.circle")
                      .resizable()
                      .frame(width: 50, height: 50)
                      .foregroundColor(.primary)
                  
                  VStack(spacing: 8) {
                      Text("You must be logged in to your Spotify account to use this feature")
                          .foregroundColor(.secondary)
                          .font(.title3)
                          .multilineTextAlignment(.center)
                          .padding()
                      
                      Button {
                          viewModel.signIn()
                          viewModel.completion = { success in
                              DispatchQueue.main.async {
                                  self.handleSignIn(success: success)
                              }
                          }
                      } label: {
                          Text("Sign In")
                              .foregroundColor(.white)
                              .padding()
                              .background(.primary)
                              .clipShape(RoundedRectangle(cornerRadius: 8))
                      }
                  }
              }
          }
          .fullScreenCover(isPresented: $tabBar) {
              TabBarView()
          }
    }}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
