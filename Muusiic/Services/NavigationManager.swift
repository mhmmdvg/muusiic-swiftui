//
//  NavigationManager.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 05/05/23.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published private(set) var destination: AnyView? = nil
    @Published var isActive: Bool = false
    
    func move(to: AnyView) {
        self.destination = to
        self.isActive = true
    }
    
    
    
}
