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
        CacheAsyncImage(url: image!) { phase in
            if let image = phase.image {
                image.resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            } else if phase.error != nil {
                Text(phase.error?.localizedDescription ?? "error")
                    .foregroundColor(.pink)
                    .frame(width: 45, height: 45)
            } else {
                ProgressView()
                    .frame(width: 45, height: 45)
            }
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
