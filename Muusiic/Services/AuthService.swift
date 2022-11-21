//
//  AuthService.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 12/11/22.
//

import Foundation

final class AuthService {
    
    static let shared = AuthService()
    private var refreshingToken = false
    
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
    
    private init(){}
    
    public var schemeURI = "muusiicapp"
    
    public var signInUrl: URL? {
        let scopes = "user-read-currently-playing,playlist-modify-private,playlist-read-private,playlist-modify-public"
        let base = "https://accounts.spotify.com/authorize"
        let redirectURI = "muusiicapp://auth"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpiration: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpiration else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeToken(token: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: token),
            URLQueryItem(name: "redirect_uri", value: "muusiicapp://auth")
        ]
        var request = URLRequest(url: url)
 
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                    error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
//                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                print(result)
                self.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
                
            }
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    public func validToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshAccessToken { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        var request = URLRequest(url: url)
 
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failed to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data,
                    error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
                
            }
        }
        task.resume()
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token,
                                       forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token,
                                           forKey: "refresh_token")
        }
 
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
    public func signOutAction(completion: (Bool) -> Void) {
        UserDefaults.standard.setValue(nil,
                                       forKey: "access_token")
        UserDefaults.standard.setValue(nil,
                                       forKey: "refresh_token")
        
        UserDefaults.standard.setValue(nil,
                                       forKey: "expirationDate")
        
        completion(true)
 
    }

}
