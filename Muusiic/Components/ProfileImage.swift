//
//  ProfileImage.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 03/05/23.
//

import SwiftUI

struct ProfileImage: View {
    
    @StateObject var userProfile = UserProfileFetcher()
    @Binding var showModal: Bool
    
    var body: some View {
        VStack {
            Button {
                self.showModal.toggle()
            } label: {
                CircleImageView(image: userProfile.userProfileFetch?.images[0].url)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
    }
}

struct ProfileImage_Previews: PreviewProvider {
    
    static var previews: some View {
        ListenNowView()
    }
}
