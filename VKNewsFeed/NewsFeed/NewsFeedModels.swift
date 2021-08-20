//
//  NewsFeedModels.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 16.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum NewsFeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsFeed
        case revealPostIds(postId: Int)
        case getUser
        case getNextBatch
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsFeed(feed: FeedResponse, revealedPostIds: [Int])
        case presentUserInfo(user: UserResponse?)
        case presentFooterLoader
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsFeed(feedViewModel: FeedViewModel)
        case displayUser(userViewModel: UserViewModel)
        case displayFooterLoaerd
      }
    }
  }
  
}

struct UserViewModel: TitleViewViewModel {
    var photoUrlString: String?
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var view: String?
        var photoAttachements: [FeedCellPhotoAttachmentViewModel]
        var sizes: FeedCellSizes
        var postId: Int

    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    let cells: [Cell]
    let footerTitle: String?
}
