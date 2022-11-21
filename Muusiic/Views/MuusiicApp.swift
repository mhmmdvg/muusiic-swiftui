//
//  MuusiicApp.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 09/09/22.
//

import SwiftUI

@main
struct MuusiicApp: App {
    var body: some Scene {
        WindowGroup {
//            LoginView()
            if AuthService.shared.isSignedIn {
                TabBarView()
            } else {
                LoginView()
            }
        }
    }
}
