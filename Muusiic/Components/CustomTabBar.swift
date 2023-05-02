//
//  CustomTabBar.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 01/05/23.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var currentTab: String
    var bottomEdge: CGFloat
    
    let tabs: [TabBarItems] = [
        TabBarItems(iconName: "play.circle.fill", title: "Listen Now"),
        TabBarItems(iconName: "magnifyingglass", title: "Search"),
        TabBarItems(iconName: "rectangle.stack.fill", title: "Library")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                TabButton(title: tab.title, image: tab.iconName, currentTab: $currentTab)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, bottomEdge - 5)
        .background(BlurView())
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
            TabBarView()
    }
}


struct TabButton: View {
    
    var title: String
    var image: String
    @Binding var currentTab: String
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor( currentTab == title ? Color.blue : Color.gray.opacity(0.7))
                .frame(maxWidth: .infinity)

            Text(title)
                .font(.system(size: 12))
                .foregroundColor(currentTab == title ? .blue : .gray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            currentTab = title
        }
        
        
    }
}

struct TabBarItems: Hashable {
    let iconName: String
    let title: String
}
