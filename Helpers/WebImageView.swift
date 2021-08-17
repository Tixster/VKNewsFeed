//
//  WebImageView.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 17.08.2021.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    
    func set(imageURL: String?) {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else { return  }
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            print("cache")
        } else {
            let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let data = data, let response = response {
                        self?.image = UIImage(data: data)
                        self?.handleLoadedImage(data: data, response: response)
                    }
                    print("inet")
                }
            }
            dataTask.resume()
        }


    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
