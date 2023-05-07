//
//  CustomNavigationView.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 03/05/23.
//

import SwiftUI

struct CustomNavigationView: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return CustomNavigationView.Coordinator(parent: self)
    }
    

    var view: SearchView
    
    var onSearch: (String) -> ()
    var onCancel: () -> ()
    
    init(view: SearchView, onSearch: @escaping (String) -> (), onCancel: @escaping () -> ()) {
        self.view = view
        self.onSearch = onSearch
        self.onCancel = onCancel
    }
    
    
    func makeUIViewController(context: Context) -> UINavigationController {
        
        let childView = UIHostingController(rootView: view)
        let controller = UINavigationController(rootViewController: childView)
        
        
        controller.navigationBar.topItem?.title = "Search"
        controller.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "What do you want to listen to?"
        
        
        searchController.searchBar.delegate = context.coordinator
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        controller.navigationBar.topItem?.searchController = searchController
        

            
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        var parent: CustomNavigationView
        
        init(parent: CustomNavigationView) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // when text change
            self.parent.onSearch(searchText)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // when cancel button
            self.parent.onCancel()
        }
    }
    
    
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
