//
//  CircleImageView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 22/11/22.
//

import SwiftUI

struct CircleImageView: View {
    
    let image: URL?
    
    var body: some View {
        AsyncImage(url: image) { image in
            image.resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
        }

//        Image(image)
//            .resizable()
//            .scaledToFit()
//            .frame(width: 45, height: 45)
//            .clipShape(Circle())
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView(image: UserProfileFetcher().userProfileFetch?.images[0].url)
    }
}
