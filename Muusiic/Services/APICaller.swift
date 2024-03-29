//
//  APICaller.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let baseAPI = "https://api.spotify.com/v1"
    }
    
    enum MethodHTTP: String {
        case GET
        case POST
        case PUT
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    
    private init() {}
    
    private func createRequest(with url: URL?,
                               type: MethodHTTP,
                               completion: @escaping (URLRequest) -> Void) {
        AuthService.shared.validToken { token in
            guard let apiUrl = url else {
                return
            }
            var request = URLRequest(url: apiUrl)
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    
// GET
    
    public func getSearch(key: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/search?q=\(key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" + "&type=track"),
            type: .GET) { baseRequest in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    do {
//                        let cek = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                        print(cek)
                        let result = try JSONDecoder().decode(SearchResult.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func getCurrentlyPlayer(completion: @escaping (Result<CurrentlyPlayer, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/me/player/currently-playing"),
            type: .GET) { baseRequest in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                
                    do {
//                        let cek = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                        print(cek)
                        let result = try JSONDecoder().decode(CurrentlyPlayer.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func getPlaylistUser(completion: @escaping (Result<PlaylistUser, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/me/playlists"),
            type: .GET) { baseRequest in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
//                        let result2 = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                        print(result2)
                        let result = try JSONDecoder().decode(PlaylistUser.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func getCategoryPlaylist(completion: @escaping (Result<CategoriesObj, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/browse/categories?country=ID&limit=20"),
            type: .GET) { baseRequest in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
//                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                        print(result)
                        let result = try JSONDecoder().decode(CategoriesObj.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func getUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/me"),
            type: .GET) { baseRequest in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(UserProfile.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    public func getRecentlyPlayed(completion: @escaping (Result<RecentlyPlayedModel, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/me/player/recently-played"),
            type: .GET) { baseRequest in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    do {
//                        let check = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                        print(check)
                        let result = try JSONDecoder().decode(RecentlyPlayedModel.self, from: data)
                        completion(.success(result))
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    
//    POST
    public func postNextPlayer(completion: @escaping (Bool) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/me/player/next"),
            type: .POST) { baseRequest in
                var request = baseRequest
                request.httpBody = try? JSONSerialization.data(withJSONObject: "", options: .fragmentsAllowed)
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let _ = data, error == nil else {
                        completion(false)
                        return
                    }
                    
                    completion(true)
                }
                task.resume()
            }
    }
    
    public func postPreviousPlayer(completion: @escaping (Bool) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/me/player/previous"),
            type: .POST) { baseRequest in
                var request = baseRequest
                request.httpBody = try? JSONSerialization.data(withJSONObject: "", options: .fragmentsAllowed)
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let _ = data, error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                task.resume()
            }
    }

    
// PUT
    public func putPausePlayer(completion: @escaping (Bool) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPI + "/me/player/pause"),
            type: .PUT) { baseRequest in
                var request = baseRequest
                request.httpBody = try? JSONSerialization.data(withJSONObject: "", options: .fragmentsAllowed)
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let _ = data, error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                task.resume()
            }
    }
    
    public func putResumeStartPlayer(completion: @escaping (Bool) -> Void) {
        getCurrentlyPlayer { [weak self] result in
            switch result {
            case .success(let progress):
                self?.createRequest(
                    with: URL(string: Constants.baseAPI + "/me/player/play"),
                    type: .PUT) { baseRequest in
                        var request = baseRequest
                        let json = [
                            "position_ms": progress.progress_ms
                        ]
                        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                        let task = URLSession.shared.dataTask(with: request) { data, _, error in
                            guard let _ = data, error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        }
                        task.resume()
                    }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
