//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 15.08.2021.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)

}

struct NetworkDataFetcher: DataFetcher {
  
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters": "post, photo"]
        networking.request(path: API.newsFeed, params: params) { data, error in
            if let error = error {
                print(error.localizedDescription)
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
            
        }

    }
    
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil}
        return response
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = AuthService.shared.userId else { return }
        let params = ["fields": "photo_100", "user_ids": userId]
        networking.request(path: API.user, params: params) { data, error in
            if let error = error {
                print(error.localizedDescription)
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }

    }
    
    
}

