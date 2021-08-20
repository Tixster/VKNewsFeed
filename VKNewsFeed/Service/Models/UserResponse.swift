//
//  UserResponse.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 20.08.2021.
//

import Foundation
import UIKit

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
    
    enum CodingKeys: String, CodingKey {
        case photo100 = "photo_100"
    }
    
}
