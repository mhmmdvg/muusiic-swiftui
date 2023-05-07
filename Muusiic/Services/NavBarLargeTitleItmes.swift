//
//  NavLarge.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 04/05/23.
//

import Foundation
import SwiftUI

public extension View {
    func navigationBarLargeTitleItems<L>(trailing: L) -> some View where L : View {
        overlay(NavigationBarLargeTitleItems(trailing: trailing).frame(width: 0, height: 0))
    }
}

struct NavigationBarLargeTitleItems<L : View>: UIViewControllerRepresentable {
    typealias UIViewControllerType = Wrapper
    
    private let trailingItems: L
    
    init(trailing: L) {
        self.trailingItems = trailing
    }
    
    func makeUIViewController(context: Context) -> Wrapper {
        Wrapper(representable: self)
    }
    
    func updateUIViewController(_ uiViewController: Wrapper, context: Context) {
    }
    
    class Wrapper: UIViewController {
        private let representable: NavigationBarLargeTitleItems?
        
        init(representable: NavigationBarLargeTitleItems) {
            self.representable = representable
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            self.representable = nil
            super.init(coder: coder)
        }
                
        override func viewWillAppear(_ animated: Bool) {
            guard let representable = self.representable else { return }
            guard let navigationBar = self.navigationController?.navigationBar else { return }
            guard let UINavigationBarLargeTitleView = NSClassFromString("_UINavigationBarLargeTitleView") else { return }
           
            navigationBar.subviews.forEach { subview in
                if subview.isKind(of: UINavigationBarLargeTitleView.self) {
                    let controller = UIHostingController(rootView: representable.trailingItems)
                    controller.view.translatesAutoresizingMaskIntoConstraints = false
                    subview.addSubview(controller.view)
                                        
                    NSLayoutConstraint.activate([
                        controller.view.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                                             constant: -Const.ImageRightMargin),
                        controller.view.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                                              constant: -Const.ImageBottomMarginForLargeState),
                        controller.view.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
                        controller.view.widthAnchor.constraint(equalTo: controller.view.heightAnchor)
                            ])
                    

                }
            }
        }
    }
}
