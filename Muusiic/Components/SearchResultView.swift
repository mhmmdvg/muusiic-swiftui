//
//  SearchResultView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 05/05/23.
//

import SwiftUI

struct SearchResultView: View {
    
    @Binding var searchResult: [SearchResultItems]
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(searchResult, id:\.self) { item in
                Button {
                    print("hahaha")
                } label: {
                    HStack(spacing: 15) {
                        CacheAsyncImage(url: item.album.images[1].url ?? URL(string: "https://i.scdn.co/image/ab67616d0000b273f0b9b2e2a024d7d87a21ffed")!) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 65, height: 65)
                                    .cornerRadius(8)
                            } else if phase.error != nil {
                                Image(systemName: "person.circle")
                                Text(phase.error?.localizedDescription ?? "error")
                                    .foregroundColor(.pink)
                                    .frame(width: 65, height: 65)
                            } else {
                                ProgressView()
                                    .frame(width: 65, height: 65)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.name)
                                .foregroundColor(.primary)
                                .font(.callout)
                                .lineLimit(1)

                            Text(item.artists[0].name)
                                .foregroundColor(.gray)
                                .font(.callout)
                                .lineLimit(1)
                            
                        }
                        
                    }
                    
                }
                Divider()
            }

        }
        .padding()
        .padding(.bottom, 80)
    }
}

struct SearchResultView_Previews: PreviewProvider {
//    @Binding var searchResult: [SearchResultItems]
    static var previews: some View {
        TabBarView()
    }
}
