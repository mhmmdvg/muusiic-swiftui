//
//  SignInViewModel.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 14/11/22.
//

import Foundation
import AuthenticationServices
import Combine

class SignInViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    private var subscriptions = [AnyCancellable]()
    public var completion: ((Bool) -> Void)?
    
    public var isSigned: Bool {
        return accessToken != nil
    }
    
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    struct Constants {
        static var clientID: String {
             get {
                 guard let filePath = Bundle.main.path(forResource: "MUUSIC-Info", ofType: "plist") else {
                     fatalError("Couldn't find file 'MUUSIC-Info.plist'.")
                 }
                 
                 let plist = NSDictionary(contentsOfFile: filePath)
                 guard let value = plist?.object(forKey: "CLIENT_ID") as? String else {
                     fatalError("Couldn't find key 'CLIENT_ID' in 'MUUSIC-Info.plist'.")
                 }
                 
                 return value
             }
         }
        
        static var clientSecret: String {
            get {
                guard let filePath = Bundle.main.path(forResource: "MUUSIC-Info", ofType: "plist") else {
                    fatalError("Couldn't find file 'MUUSIC-Info.plist'.")
                }
                
                let plist = NSDictionary(contentsOfFile: filePath)
                guard let value = plist?.object(forKey: "CLIENT_SECRET") as? String else {
                    fatalError("Couldn't find key 'CLIENT_SECRET' in 'MUUSIC-Info.plist'.")
                }
                
                return value
            }
        }
        
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func signIn() {
        let signInPromise = Future<URL, Error> { completion in
            let authUrl = AuthService.shared.signInUrl
            
            let authSession = ASWebAuthenticationSession(url: authUrl!, callbackURLScheme: AuthService.shared.schemeURI) { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                }
            }
            
            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = true
            authSession.start()
        }
        
        signInPromise.sink { (completion) in
            switch completion {
            case .failure(let error):
                print(error)
            default: break
            }
        } receiveValue: { (url) in
//            print("this is url \(url)")
            guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
                return
            }
            AuthService.shared.exchangeToken(token: code) { [weak self] success in
                DispatchQueue.main.async {
                    self?.completion?(success)
                }
            }
        }
        .store(in: &self.subscriptions)
    }
    
   
}
