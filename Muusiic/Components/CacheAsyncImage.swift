//
//  CacheAsyncImage.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 29/04/23.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    
    private let url: URL
    private let scale: CGFloat
    private let transcation: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transcation = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
//            let _ = print("cached \(url.absoluteString)")
            content(.success(cached))
        } else {
//            let _ = print("request \(url.absoluteString)")
            AsyncImage(url: url, scale: scale, transaction: transcation) { phase in
               cacheAndRender(phase: phase)
            }
        }
    }
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        
        return content(phase)
    }
}

struct CacheAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CacheAsyncImage(url: URL(string: "https://i.scdn.co/image/ab67616d0000b273f0b9b2e2a024d7d87a21ffed")!) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
            case .failure(let error):
                Text(error.localizedDescription)
            @unknown default:
                fatalError()
            }
        }
    }
}


fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
