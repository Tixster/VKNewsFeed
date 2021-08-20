//
//  NetworkService.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 14.08.2021.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService {
    
    private let authService = AuthService.shared
    
    private func url(from path: String, params: [String: String]) -> URL {
        var compomtets = URLComponents()
        compomtets.scheme = API.scheme
        compomtets.host = API.host
        compomtets.path = path
        compomtets.queryItems = params.map({ URLQueryItem(name: $0, value: $1) })
        
        return compomtets.url!
    }
    
    private func createDataTask(from request:  URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, respones, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
}

extension NetworkService: Networking {
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        
        let url = self.url(from: path, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        
    }
    
    
}
