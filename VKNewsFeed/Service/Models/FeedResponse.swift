//
//  FeedRespose.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 15.08.2021.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItems]
    var profiles: [Profile]
    var groups: [Group]
}

struct FeedItems: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachment]?
    
    enum CodingKeys: String, CodingKey {
        case sourceId = "source_id"
        case postId = "post_id"
        case text, date, comments, likes, reposts, views, attachments
    }
}

struct Attachment: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: [PhotoSize]
    
    var height: Int {
        return getPropperSize().height
    }
    
    var width: Int {
        return getPropperSize().width
    }
    
    var srcBIG: String {
        return getPropperSize().url
    }
    
    private func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}


struct CountableItem: Decodable {
    let count: Int
}

protocol ProfileReperesentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct Profile: Decodable, ProfileReperesentable {
    
    var name: String { return firstName + " " + lastName }
    var photo: String { return photo100 }
    
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
        case id
    }
    
}

struct Group: Decodable, ProfileReperesentable {
    
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String { return photo100 }
    
    enum CodingKeys: String, CodingKey {
        case photo100 = "photo_100"
        case id, name
    }
    
}

