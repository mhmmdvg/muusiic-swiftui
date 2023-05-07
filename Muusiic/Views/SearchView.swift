//
//  SearchView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 10/11/22.
//

import SwiftUI

struct SearchView: View {
    
    
    @Binding var query: String
    @Binding var searchResult: [SearchResultItems]
    
    @StateObject var categoriesPlaylists = CategoriesPlaylistFetcher()
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    
    var body: some View {
            ScrollView {
                if query != "" {
                    SearchResultView(searchResult: self.$searchResult)
                } else {
                    VStack(spacing: 18) {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(categoriesPlaylists.categories, id: \.self) { item in
                                Button(action: {}) {
                                    CacheAsyncImage(url: item.icons[0].url) { phase in
                                        if let image = phase.image {
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 120)
                                                .cornerRadius(12)
                                        } else if phase.error != nil {
                                            Text(phase.error?.localizedDescription ?? "error")
                                                .foregroundColor(.pink)
                                                .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 120)
                                        } else {
                                            ProgressView()
                                                .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 120)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 80)
                }
            }
//        .searchable(text: $search)
//        .onAppear {
//            URLCache.shared.memoryCapacity = 1024 * 1024 * 512
//        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
