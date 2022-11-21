//
//  BlurView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 10/11/22.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
        
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}
