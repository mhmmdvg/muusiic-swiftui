//
//  SearchView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 10/11/22.
//

import SwiftUI

struct SearchView: View {
    
    @State var search = ""
    
    @Binding var isTyping: Bool
    
    @StateObject var categoriesPlaylists = CategoriesPlaylistFetcher()
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 18) {
                    HStack(spacing: 15) {
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                        
                        TextField("Search", text: $search) {
                            self.isTyping = $0
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.primary.opacity(0.06))
                    .cornerRadius(15)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        ForEach(categoriesPlaylists.categories, id: \.self) { item in
                            Button(action: {}) {
                                AsyncImage(url: item.icons[0].url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 120)
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
                .padding(.bottom, 80)
            }
            .navigationTitle("Search")
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
